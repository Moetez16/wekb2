<%@ page import="grails.plugin.springsecurity.SpringSecurityUtils; wekb.helper.RCConstants; wekb.helper.RDStore;" %>
<wekb:serviceInjection/>
<g:set var="user" scope="page" value="${springSecurityService.currentUser}"/>

<g:if test="${d}">
    <semui:tabs>

        <semui:tabsItemWithoutLink tab="statistic" defaultTab="statistic" activeTab="${params.activeTab}">
            Statistic
        </semui:tabsItemWithoutLink>
        <g:if test="${user && (SpringSecurityUtils.ifAnyGranted("ROLE_ADMIN, ROLE_SUSHI") || user.curatoryGroupUsers.curatoryGroup.id.intersect(d.curatoryGroups.curatoryGroup.id))}">
            <semui:tabsItemWithoutLink tab="sushiApiInfo" activeTab="${params.activeTab}">
                Sushi Api Key Information
            </semui:tabsItemWithoutLink>
        </g:if>
        <semui:tabsItemWithoutLink tab="accessibility" activeTab="${params.activeTab}">
            Accessibility
        </semui:tabsItemWithoutLink>
        <semui:tabsItemWithoutLink tab="titledetails" activeTab="${params.activeTab}" counts="${d.currentTippCount}">
            Hosted Titles
        </semui:tabsItemWithoutLink>
        <semui:tabsItemWithoutLink tab="packages" activeTab="${params.activeTab}" counts="${d.hostedPackages.size()}">
            Packages
        </semui:tabsItemWithoutLink>
    </semui:tabs>

    <semui:tabsItemContent tab="titledetails" activeTab="${params.activeTab}">
        <g:link class="display-inline" controller="search" action="inlineSearch"
                params="[s_controllerName: controllerName, s_actionName: actionName, objectUUID: params.id, max: params.max, offset: params.offset, sort: params.sort, order: params.order, qbe: 'g:tipps', qp_plat_id: d.id, inline: true, refOID: d.getOID(), hide: ['qp_plat', 'qp_plat_id'], qp_status: wekb.RefdataValue.class.name + ':' + RDStore.KBC_STATUS_CURRENT.id, activeTab: 'titledetails']"
                id="">Titles on this Platform</g:link>
    </semui:tabsItemContent>

    <semui:tabsItemContent tab="packages" activeTab="${params.activeTab}">
        <g:link class="display-inline" controller="search" action="inlineSearch"
                params="[s_controllerName: controllerName, s_actionName: actionName, objectUUID: params.id, max: params.max, offset: params.offset, sort: params.sort, order: params.order, qbe: 'g:packages', qp_platform_id: d.id, inline: true, refOID: d.getOID(), hide: ['qp_platform', 'qp_platform_id'], activeTab: 'packages']"
                id="">Packages on this Platform</g:link>
    </semui:tabsItemContent>

    <semui:tabsItemContent tab="statistic" defaultTab="statistic" activeTab="${params.activeTab}">
        <div class="content wekb-inline-lists">
            <dl>
                <dt class="control-label">
                    Statistics Format
                </dt>
                <dd>
                    <semui:xEditableRefData owner="${d}" field="statisticsFormat"
                                            config="${RCConstants.PLATFORM_STATISTICS_FORMAT}"/>
                </dd>
            </dl>
            <dl>
                <dt class="control-label">
                    Statistics Update
                </dt>
                <dd>
                    <semui:xEditableRefData owner="${d}" field="statisticsUpdate"
                                            config="${RCConstants.PLATFORM_STATISTICS_UPDATE}"/>
                </dd>
            </dl>
            <dl>
                <dt class="control-label">
                    Statistics Admin Portal Url
                </dt>
                <dd>
                    <semui:xEditable owner="${d}" field="statisticsAdminPortalUrl" validation="url" outGoingLink="true"/>
                </dd>
            </dl>
            <dl>
                <dt class="control-label">
                    Counter Certified
                </dt>
                <dd>
                    <semui:xEditableRefData owner="${d}" field="counterCertified" config="${RCConstants.YN}"/>
                </dd>
            </dl>
            <dl>
                <dt class="control-label">
                    Last Audit Date
                </dt>
                <dd>
                    <semui:xEditable owner="${d}" field="lastAuditDate" type="date"/>
                </dd>
            </dl>
            <dl>
                <dt class="control-label">
                    Counter Registry Url
                </dt>
                <dd>
                    <semui:xEditable owner="${d}" field="counterRegistryUrl" validation="url" outGoingLink="true"/>
                </dd>
            </dl>
            <dl>
                <dt class="control-label">
                    Counter R3 Supported
                </dt>
                <dd>
                    <semui:xEditableRefData owner="${d}" field="counterR3Supported" config="${RCConstants.YN}"/>
                </dd>
            </dl>
            <dl>
                <dt class="control-label">
                    Counter R4 Supported
                </dt>
                <dd>
                    <semui:xEditableRefData owner="${d}" field="counterR4Supported" config="${RCConstants.YN}"/>
                </dd>
            </dl>
            <dl>
                <dt class="control-label">
                    Counter R5 Supported
                </dt>
                <dd>
                    <semui:xEditableRefData owner="${d}" field="counterR5Supported" config="${RCConstants.YN}"/>
                </dd>
            </dl>
            <dl>
                <dt class="control-label">
                    Counter R4 Sushi Api Supported
                </dt>
                <dd>
                    <semui:xEditableRefData owner="${d}" field="counterR4SushiApiSupported"
                                            config="${RCConstants.YN}"/>
                </dd>
            </dl>
            <dl>
                <dt class="control-label">
                    Counter R5 Sushi Api Supported
                </dt>
                <dd>
                    <semui:xEditableRefData owner="${d}" field="counterR5SushiApiSupported"
                                            config="${RCConstants.YN}"/>
                </dd>
            </dl>
            <dl>
                <dt class="control-label">
                    Counter R4 Sushi Server Url
                </dt>
                <dd>
                    <semui:xEditable owner="${d}" field="counterR4SushiServerUrl" validation="url"/>
                </dd>
            </dl>
            <dl>
                <dt class="control-label">
                    Counter R5 Sushi Server Url
                </dt>
                <dd>
                    <semui:xEditable owner="${d}" field="counterR5SushiServerUrl" validation="url"/>
                </dd>

            </dl>
            <dl>
                <dt class="control-label">
                    Counter R5 Sushi Platform Name
                </dt>
                <dd>
                    <semui:xEditable owner="${d}" field="counterR5SushiPlatform"/>
                </dd>

            </dl>
        </div>
    </semui:tabsItemContent>

    <g:if test="${user && (SpringSecurityUtils.ifAnyGranted("ROLE_ADMIN, ROLE_SUSHI") || user.curatoryGroupUsers.curatoryGroup.id.intersect(d.curatoryGroups.curatoryGroup.id))}">

        <semui:tabsItemContent tab="sushiApiInfo" activeTab="${params.activeTab}">
            <div class="content wekb-inline-lists">
                <dl>
                    <dt class="control-label">
                        Sushi Api Authentication Method
                    </dt>
                    <dd>
                        <semui:xEditableRefData owner="${d}" field="sushiApiAuthenticationMethod"
                                                config="${RCConstants.PLATFORM_SUSHI_API_AUTH_METHOD}"/>
                    </dd>
                </dl>
                <dl>
                    <dt class="control-label">
                        Central Api Key
                    </dt>
                    <dd>
                        <semui:xEditable owner="${d}" field="centralApiKey"/>
                    </dd>
                </dl>
            </div>
        </semui:tabsItemContent>
    </g:if>

    <semui:tabsItemContent tab="accessibility" activeTab="${params.activeTab}">
        <div class="sixteen wide column">
            <div class="ui segment">
                <div class="content wekb-inline-lists">
                    <h2 class="ui header">Platform</h2>
                    <div class="description">
                        <dl>
                            <dt class="ui header wekb-header">Accessibility requirements according to
                                <g:link url="https://www.barrierefreiheit-dienstekonsolidierung.bund.de/Webs/PB/DE/gesetze-und-richtlinien/en301549/en301549-node.html"
                                        target="_blank">
                                    EN 301549
                                </g:link>
                            </dt>
                            <dd></dd>
                        </dl>

                        <dl>
                            <dt class="control-label">
                                Accessibility of the platform
                            </dt>
                            <dd>
                                <semui:xEditableRefData owner="${d}" field="accessPlatform"
                                                        config="${RCConstants.UYNP}"/>
                            </dd>
                            <dd></dd>
                        </dl>
                        <dl>
                            <dt class="control-label">
                                Accessibility of the audio player
                            </dt>
                            <dd>
                                <semui:xEditableRefData owner="${d}" field="playerForAudio"
                                                        config="${RCConstants.UYNP}"/>
                            </dd>
                        </dl>
                        <dl>
                            <dt class="control-label">
                                Accessibility of the video player
                            </dt>
                            <dd>
                                <semui:xEditableRefData owner="${d}" field="playerForVideo"
                                                        config="${RCConstants.UYNP}"/>
                            </dd>
                        </dl>
                        <dl>
                            <dt class="ui header wekb-header">Accessibility Statement</dt>
                            <dd></dd>
                        </dl>
                        <dl>
                            <dt class="control-label">
                                Accessibility Statement available
                            </dt>
                            <dd>
                                <semui:xEditableRefData owner="${d}" field="accessibilityStatementAvailable" config="${RCConstants.YN}"/>
                            </dd>
                        </dl>
                        <dl>
                            <dt class="control-label">
                                Link to the Accessibility Statement
                            </dt>
                            <dd>
                                <semui:xEditable owner="${d}" field="accessibilityStatementUrl" validation="url" outGoingLink="true"/>
                            </dd>
                        </dl>
                    </div>
                </div>
            </div>

            <div class="ui segment">
                <div class="content wekb-inline-lists">
                    <h2 class="ui header">Content on the platform</h2>
                    <div class="description">
                        <dl>
                            <dt class="ui header wekb-header">eBook</dt>
                            <dd></dd>
                        </dl>
                        <dl>
                            <dt class="control-label">
                                Current <g:link url="https://www.w3.org/TR/epub-33/"
                                                       target="_blank">
                                    ePub-Standard
                                </g:link>
                            </dt>
                            <dd>
                                <semui:xEditableRefData owner="${d}" field="ebookEPub" config="${RCConstants.UYN}"/>
                            </dd>
                        </dl>
                        <dl>
                            <dt class="control-label">
                                <g:link url="https://www.dnb.de/DE/Professionell/Sammeln/Unkoerperliche_Medienwerke/_content/onix_for_books_2_1_akk.html"
                                        target="_blank">
                                    ONIX Metadata to accessibility
                                </g:link>
                            </dt>
                            <dd>
                                <semui:xEditableRefData owner="${d}" field="onixMetadata" config="${RCConstants.UYN}"/>
                            </dd>
                        </dl>
                        <dl>
                            <dt class="ui header wekb-header">PDF</dt>
                            <dd></dd>
                        </dl>
                        <dl>
                            <dt class="control-label">
                                PDF/UA-Standard  <g:link url="https://www.pdfa.org/wp-content/uploads/2016/08/MatterhornProtokoll_1-02-2016-06-29.pdf"
                                                              target="_blank">
                                    (Matterhorn Protocol)
                                </g:link>
                            </dt>
                            <dd>
                                <semui:xEditableRefData owner="${d}" field="pdfUaStandard" config="${RCConstants.UYN}"/>
                            </dd>
                        </dl>
                        <dl>
                            <dt class="ui header wekb-header">Video</dt>
                            <dd></dd>
                        </dl>
                        <dl>
                            <dt class="control-label">
                                Audio description available
                            </dt>
                            <dd>
                                <semui:xEditableRefData owner="${d}" field="videoAudioDes" config="${RCConstants.UYN}"/>
                            </dd>
                        </dl>
                        <dl>
                            <dt class="control-label">
                                Subtitles available
                            </dt>
                            <dd>
                                <semui:xEditableRefData owner="${d}" field="videoSubTitles" config="${RCConstants.UYN}"/>
                            </dd>
                        </dl>
                        <dl>
                            <dt class="ui header wekb-header">Database</dt>
                            <dd></dd>
                        </dl>
                        <dl>
                            <dt class="control-label">
                                Accessibility according to
                                <g:link url="https://www.barrierefreiheit-dienstekonsolidierung.bund.de/Webs/PB/DE/gesetze-und-richtlinien/en301549/en301549-node.html"
                                        target="_blank">
                                    EN 301549
                                </g:link>
                            </dt>
                            <dd>
                                <semui:xEditableRefData owner="${d}" field="databaseBarrierFree" config="${RCConstants.UYN}"/>
                            </dd>
                        </dl>

                    </div>
                </div>
            </div>
        </div>
    </semui:tabsItemContent>

</g:if>
