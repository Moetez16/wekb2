package wekb

import wekb.helper.RCConstants
import wekb.helper.RDStore

import javax.persistence.Transient
import java.sql.Timestamp

class Source extends KBComponent {

  String url
  String defaultAccessURL
  String explanationAtSource
  String contextualNotes
  // Org combo -- What organisation - aggregator -- responsibleParty
  Boolean automaticUpdates = false
  RefdataValue frequency
  String ruleset
  // Default method refdata - email web ftp other
  // Default data Format KBART,Prop
  RefdataValue defaultSupplyMethod
  RefdataValue defaultDataFormat
  IdentifierNamespace targetNamespace
  Date lastRun
  String lastUpdateUrl
  Boolean zdbMatch = false
  Boolean ezbMatch = false
  //Org responsibleParty

  Boolean kbartHasWekbFields = false
  Date lastChangedInKbart

  static manyByCombo = [
    curatoryGroups: CuratoryGroup
  ]

  static mapping = {
    includes KBComponent.mapping
    url column:'source_url'
    ruleset column:'source_ruleset', type:'text'
    lastUpdateUrl column: 'source_last_update_url'
    kbartHasWekbFields column: 'source_kbart_wekb_fields'
    lastChangedInKbart column: 'source_last_changed_in_kbart'
  }

  static constraints = {
    url(nullable:true, blank:true)
    defaultAccessURL(nullable:true, blank:true)
    explanationAtSource(nullable:true, blank:true)
    contextualNotes(nullable:true, blank:true)
    frequency(nullable:true, blank:true)
    defaultSupplyMethod(nullable:true, blank:true)
    defaultDataFormat(nullable:true, blank:true)
    ruleset(nullable:true, blank:true)
    targetNamespace(nullable:true, blank:true)
    lastRun(nullable:true,default: null)
    ezbMatch(nullable:true, default: false)
    zdbMatch(nullable:true,default: false)
    automaticUpdates(nullable: true,default: false)
    lastUpdateUrl(nullable:true, blank:true)
    lastChangedInKbart (nullable:true, default: null)
    name(validator: { val, obj ->
      if (obj.hasChanged('name')) {
        if (val && val.trim()) {
          def status_deleted = RefdataCategory.lookup(RCConstants.KBCOMPONENT_STATUS, 'Deleted')
          def dupes = Source.findAllByNameIlikeAndStatusNotEqual(val, status_deleted);

          if (dupes.size() > 0 && dupes.any {it != obj}) {
            return ['notUnique']
          }
        }
        else {
          return ['notNull']
        }
      }
    })
  }

  static def refdataFind(params) {
    def result = [];
    def status_deleted = RDStore.KBC_STATUS_DELETED
    def status_filter = null

    if(params.filter1) {
      status_filter = RefdataCategory.lookup(RCConstants.KBCOMPONENT_STATUS, params.filter1)
    }

    params.sort = 'name'

    def ql = null;
    ql = Source.findAllByNameIlikeAndStatusNotEqual("${params.q}%", status_deleted, params)

    if ( ql ) {
      ql.each { t ->
        if( !status_filter || t.status == status_filter ){
          result.add([id:"${t.class.name}:${t.id}",text:"${t.name}", status:"${t.status?.value}"])
        }
      }
    }

    result
  }

  boolean needsUpdate() {
    if (lastRun == null) {
      return true
    }
    if (frequency != null) {
      Date today = new Date()
      def interval = intervals.get(frequency.value)
      if (interval != null){
        Date due = getUpdateDay(interval)
        if (today == due){
          return true
        }
      }else {
        log.info("Source needsUpdate(): Frequency (${frequency}) is not null but intervals is null")
      }
    }else {
      log.info("Source needsUpdate(): Frequency is null")
    }
    return false
  }


  def getUpdateDay(int interval){
    Date today = new Date()
    // calculate from each first day of the year to not create a lag over the years
    Calendar cal = Calendar.getInstance()
    cal.set(Calendar.YEAR, cal.get(Calendar.YEAR))
    cal.set(Calendar.DAY_OF_YEAR, 1)
    Date nextUpdate = cal.getTime()
    while (nextUpdate.before(today)){
      nextUpdate = nextUpdate.plus(interval)
    }
    return nextUpdate
  }

  List getUpdateDays(int interval){
    Date today = new Date()
    List<Date> updateDays = []
    // calculate from each first day of the year to not create a lag over the years
    Calendar cal = Calendar.getInstance()
    cal.set(Calendar.YEAR, cal.get(Calendar.YEAR))
    cal.set(Calendar.DAY_OF_YEAR, 1)
    Calendar cal2 = Calendar.getInstance()
    cal2.set(Calendar.YEAR, cal.get(Calendar.YEAR))
    cal2.set(Calendar.MONTH, 11) // 11 = december
    cal2.set(Calendar.DAY_OF_MONTH, 31) // new years eve
    Date nextUpdate = cal.getTime()
    Date lastUpdate = cal2.getTime()
    while (nextUpdate.before(lastUpdate)){
      nextUpdate = nextUpdate.plus(interval)
      updateDays << nextUpdate
    }
    return updateDays
  }


  def intervals = [
      "Daily"       : 1,
      "Weekly"      : 7,
      "Monthly"     : 30,
      "Quarterly"   : 91,
      "Yearly"      : 365,
  ]

  @Transient
  def availableActions() {
    [
            [code: 'method::deleteSoft', label: 'Delete Source', perm: 'delete'],
            [code: 'setStatus::Removed', label: 'Remove Source', perm: 'delete'],
    ]
  }

  public void deleteSoft(context) {
    // Call the delete method on the superClass.
    super.deleteSoft(context)

    Package.findAllBySource(this).each {
      it.source = null
      it.save(flush: true, failOnError: true)
    }

  }

  @Transient
  Timestamp getNextUpdateTimestamp() {
    //20:00:00 is time of Cronjob in AutoUpdatePackagesJob
    if (automaticUpdates && lastRun == null) {
      return Date.parse('dd.MM.yy hh:mm:SS', "${new Date().getDateString()} 20:00:00").toTimestamp()
    }
    if (automaticUpdates && frequency != null) {
      def interval = intervals.get(frequency.value)
      if (interval != null){
        Date due = getUpdateDay(interval)
          return Date.parse('dd.MM.yy hh:mm:SS', "${due.getDateString()} 20:00:00").toTimestamp()
      }else {
        log.info("Source needsUpdate(): Frequency (${frequency}) is not null but intervals is null")
      }
    }else {
      log.info("Source needsUpdate(): Frequency is null")
    }
    return null
  }

  @Transient
  List<Timestamp> getAllNextUpdateTimestamp() {
    //20:00:00 is time of Cronjob in AutoUpdatePackagesJob
    if (automaticUpdates && frequency != null) {
      def interval = intervals.get(frequency.value)
      if (interval != null && interval > 1){
        List<Date> due = getUpdateDays(interval)
        List<Timestamp> timestampList = []
        due.each {
          timestampList << Date.parse('dd.MM.yy hh:mm:SS', "${it.getDateString()} 20:00:00").toTimestamp()
        }
        return timestampList
      }
    }
    return null
  }

  @Transient
  public String getDomainName() {
    return "Source"
  }

  @Transient
  public List<Package> getPackages() {
    def result = Package.findAllBySource(this)
    result
  }

}
