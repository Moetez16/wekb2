<%@ page import="wekb.helper.RDStore; wekb.RefdataCategory; wekb.helper.RCConstants" %>
<g:if test="${d.id}">
    <semui:tabs>
        <semui:tabsItemWithoutLink tab="invoice" defaultTab="invoice" activeTab="${params.activeTab}">
            Invoicing
        </semui:tabsItemWithoutLink>
        <semui:tabsItemWithoutLink tab="identifiers" activeTab="${params.activeTab}" counts="${d.ids.size()}">
            Identifiers
        </semui:tabsItemWithoutLink>
        <semui:tabsItemWithoutLink tab="variantNames" activeTab="${params.activeTab}" counts="${d.variantNames.size()}">
            Alternate Names
        </semui:tabsItemWithoutLink>
        <semui:tabsItemWithoutLink tab="packages" activeTab="${params.activeTab}" counts="${d.providedPackages.size()}">
            Packages
        </semui:tabsItemWithoutLink>
        <semui:tabsItemWithoutLink tab="titles" activeTab="${params.activeTab}" counts="${d.getCurrentTippCount()}">
            Titles
        </semui:tabsItemWithoutLink>
        <semui:tabsItemWithoutLink tab="platforms" activeTab="${params.activeTab}" counts="${d.getProvidedPlatforms().size()}">
            Platforms
        </semui:tabsItemWithoutLink>
    </semui:tabs>


    <g:render template="/templates/tabTemplates/identifiersTab" model="${[d: d, defaultTab: 'identifiers']}"/>

    <g:render template="/templates/tabTemplates/variantNamesTab" model="${[d: d, showActions: true]}"/>

    <semui:tabsItemContent tab="invoice" activeTab="${params.activeTab}">
        <div class="content wekb-inline-lists">
            <dl>
                <dt class="control-label">
                    Inhouse Invoicing
                </dt>
                <dd>
                    <g:if test="${editable}">
                        <g:form controller="ajaxHtml" action="setInvoicingYourself" id="${d.id}">
                            <g:select from="${RefdataCategory.lookup(RCConstants.YN).sort { it.value }}"
                                      class="ui dropdown fluid"
                                      id="invoicingYourself"
                                      optionKey="value"
                                      optionValue="${{ it.getI10n('value') }}"
                                      name="invoicingYourself"
                                      value="${d.invoicingYourself ? RDStore.YN_YES.value : RDStore.YN_NO.value}" onChange="this.form.submit()"/>
                        </g:form>
                    </g:if>
                    <g:else>
                        ${d.invoicingYourself ? RDStore.YN_YES.getI10n('value') : RDStore.YN_NO.getI10n('value') }
                    </g:else>
                </dd>
            </dl>
                <g:if test="${d.invoicingYourself}">
                    <div class="ui segment">
                        <div class="ui top attached label">Independent Invoicing Informationen</div>
                        <div class="content wekb-inline-lists">
                            <dl>
                                <dt class="control-label">
                                    Electronic Invoice Formats
                                </dt>
                                <dd>
                                    <table class="ui small selectable striped celled table">
                                        <thead>
                                        <tr>
                                            <th>#</th>
                                            <th>Format</th>
                                            <g:if test="${editable}">
                                                <th>Action</th>
                                            </g:if>
                                        </tr>
                                        </thead>
                                        <tbody>
                                        <g:each in="${d.electronicBillings.sort { it.electronicBilling.value }}"
                                                var="vendorElectronicBilling" status="i">
                                            <tr>
                                                <td>${i + 1}</td>
                                            <td><semui:xEditableRefData owner="${vendorElectronicBilling}" field="electronicBilling"
                                                config="${RCConstants.VENDOR_ELECTRONIC_BILLING}"/>
                                                <g:if test="${editable}">
                                                    <td>

                                                        <g:link controller='ajaxHtml'
                                                                action='delete'
                                                                params="${["__context": "${vendorElectronicBilling.getOID()}", curationOverride: params.curationOverride]}">Delete</g:link>

                                                    </td>
                                                </g:if>
                                            </tr>
                                        </g:each>
                                        </tbody>
                                    </table>

                                    <g:if test="${editable}">
                                        <a class="ui right floated primary button" href="#"
                                           onclick="$('#electronicBillingsModal').modal('show');">Add Electronic Invoice Format</a>

                                        <br>
                                        <br>

                                        <semui:modal id="electronicBillingsModal" title="Add supported Library System">

                                            <g:form controller="ajaxHtml" action="addToCollection" class="ui form">
                                                <input type="hidden" name="__context" value="${d.getOID()}"/>
                                                <input type="hidden" name="__newObjectClass" value="wekb.ProviderElectronicBilling"/>
                                                <input type="hidden" name="__recip" value="provider"/>
                                                <input type="hidden" name="curationOverride" value="${params.curationOverride}"/>
                                                <input type="hidden" name="activeTab" value="invoice"/>


                                                <div class="field">
                                                    <label>Electronic Invoice Format:</label> <semui:simpleReferenceDropdown
                                                        name="electronicBilling"
                                                        baseClass="wekb.RefdataValue"
                                                        filter1="${RCConstants.VENDOR_ELECTRONIC_BILLING}"/>
                                                </div>
                                            </g:form>
                                        </semui:modal>
                                    </g:if>
                                </dd>
                            </dl>
                            <dl>
                                <dt class="control-label">
                                    Invoice dispatch via
                                </dt>
                                <dd>

                                    <table class="ui small selectable striped celled table">
                                        <thead>
                                        <tr>
                                            <th>#</th>
                                            <th>Method</th>
                                            <g:if test="${editable}">
                                                <th>Action</th>
                                            </g:if>
                                        </tr>
                                        </thead>
                                        <tbody>
                                        <g:each in="${d.invoiceDispatchs.sort { it.invoiceDispatch.value }}" var="vendorInvoiceDispatch"
                                                status="i">
                                            <tr>
                                                <td>${i + 1}</td>
                                            <td><semui:xEditableRefData owner="${vendorInvoiceDispatch}" field="invoiceDispatch"
                                                config="${RCConstants.VENDOR_INVOICE_DISPATCH}"/>
                                                <g:if test="${editable}">
                                                    <td>
                                                        <g:link controller='ajaxHtml'
                                                                action='delete'
                                                                params="${["__context": "${vendorInvoiceDispatch.getOID()}", curationOverride: params.curationOverride]}">Delete</g:link>

                                                    </td>
                                                </g:if>
                                            </tr>
                                        </g:each>
                                        </tbody>
                                    </table>

                                    <g:if test="${editable}">
                                        <a class="ui right floated primary button" href="#"
                                           onclick="$('#invoiceDispatchsModal').modal('show');">Add Invoice dispatch</a>

                                        <br>
                                        <br>

                                        <semui:modal id="invoiceDispatchsModal" title="Add supported Library System">

                                            <g:form controller="ajaxHtml" action="addToCollection" class="ui form">
                                                <input type="hidden" name="__context" value="${d.getOID()}"/>
                                                <input type="hidden" name="__newObjectClass" value="wekb.ProviderInvoiceDispatch"/>
                                                <input type="hidden" name="__recip" value="provider"/>
                                                <input type="hidden" name="curationOverride" value="${params.curationOverride}"/>
                                                <input type="hidden" name="activeTab" value="invoice"/>


                                                <div class="field">
                                                    <label>Method:</label> <semui:simpleReferenceDropdown
                                                        name="invoiceDispatch"
                                                        baseClass="wekb.RefdataValue"
                                                        filter1="${RCConstants.VENDOR_INVOICE_DISPATCH}"/>
                                                </div>
                                            </g:form>
                                        </semui:modal>
                                    </g:if>
                                </dd>
                            </dl>
                            <dl>
                                <dt class="control-label">
                                    Paper Invoice
                                </dt>
                                <dd>
                                    <semui:xEditableRefData owner="${d}" field="paperInvoice"
                                                            config="${RCConstants.YN}"/>
                                </dd>
                            </dl>
                            <dl>
                                <dt class="control-label">
                                    Management of Credits
                                </dt>
                                <dd>
                                    <semui:xEditableRefData owner="${d}" field="managementOfCredits"
                                                            config="${RCConstants.YN}"/>
                                </dd>
                            </dl>
                            <dl>
                                <dt class="control-label">
                                    Processing of compensation payments (credits/subsequent debits)
                                </dt>
                                <dd>
                                    <semui:xEditableRefData owner="${d}" field="processingOfCompensationPayments"
                                                            config="${RCConstants.YN}"/>
                                </dd>
                            </dl>
                            <dl>
                                <dt class="control-label">
                                    Individual invoice design
                                </dt>
                                <dd>
                                    <semui:xEditableRefData owner="${d}" field="individualInvoiceDesign"
                                                            config="${RCConstants.YN}"/>
                                </dd>
                            </dl>
                        </div>
                    </div>
                </g:if>
        </div>

        <div class="content wekb-inline-lists">
            <dl>
                <dt class="control-label">
                    Invoicing possible by vendor
                </dt>
                <dd>

                    <table class="ui small selectable striped celled table">
                        <thead>
                        <tr>
                            <th>#</th>
                            <th>Vendor</th>
                            <g:if test="${editable}">
                                <th>Action</th>
                            </g:if>
                        </tr>
                        </thead>
                        <tbody>
                        <g:each in="${d.invoicingVendors.sort { it.vendor.name }}" var="invoicingVendor"
                                status="i">
                            <tr>
                                <td>${i + 1}</td>
                            <td>
                                <g:link controller="resource" action="show" id="${invoicingVendor.vendor.getOID()}"> ${invoicingVendor.vendor.name}</g:link>
                                <g:if test="${editable}">
                                    <td>
                                        <g:link controller='ajaxHtml'
                                                action='delete'
                                                params="${["__context": "${invoicingVendor.getOID()}", curationOverride: params.curationOverride]}">Delete</g:link>

                                    </td>
                                </g:if>
                            </tr>
                        </g:each>
                        </tbody>
                    </table>

                    <g:if test="${editable}">
                        <a class="ui right floated primary button" href="#"
                           onclick="$('#invoicingVendorsModal').modal('show');">Add Vendor</a>

                        <br>
                        <br>

                        <semui:modal id="invoicingVendorsModal" title="Add Vendor">

                            <g:form controller="ajaxHtml" action="addToCollection" class="ui form">
                                <input type="hidden" name="__context" value="${d.getOID()}"/>
                                <input type="hidden" name="__newObjectClass" value="wekb.ProviderInvoicingVendor"/>
                                <input type="hidden" name="__recip" value="provider"/>
                                <input type="hidden" name="curationOverride" value="${params.curationOverride}"/>
                                <input type="hidden" name="activeTab" value="invoice"/>


                                <div class="field">
                                    <label>Vendor:</label> <semui:simpleReferenceDropdown
                                        name="vendor"
                                        baseClass="wekb.Vendor"/>
                                </div>
                            </g:form>
                        </semui:modal>
                    </g:if>
                </dd>
            </dl>
        </div>
    </semui:tabsItemContent>

    <semui:tabsItemContent tab="platforms" activeTab="${params.activeTab}">
        <g:link class="display-inline" controller="search" action="inlineSearch"
                params="[s_controllerName: controllerName, s_actionName: actionName, objectUUID: params.id, max: params.max, offset: params.activeTab == 'platforms' ? params.offset : '', sort: params.sort, order: params.order, qbe: 'g:platforms', refOID: d.getOID(), inline: true, qp_provider_id: d.id, hide: ['qp_provider', 'qp_provider_id'], activeTab: 'platforms', jumpOffset: params.activeTab == 'platforms' ? params.jumpOffset : '']"
                id="">Titles published</g:link>
    </semui:tabsItemContent>
    <semui:tabsItemContent tab="titles" activeTab="${params.activeTab}">
        <g:link class="display-inline" controller="search" action="inlineSearch"
                params="[s_controllerName: controllerName, s_actionName: actionName, objectUUID: params.id, max: params.max, offset: params.activeTab == 'titles' ? params.offset : '', sort: params.sort, order: params.order, qbe: 'g:tipps', refOID: d.getOID(), inline: true, qp_provider_id: d.id, hide: ['qp_provider', 'qp_provider_id'], activeTab: 'titles', jumpOffset: params.activeTab == 'titles' ? params.jumpOffset : '']"
                id="">Titles published</g:link>
    </semui:tabsItemContent>

    <semui:tabsItemContent tab="packages" activeTab="${params.activeTab}">
        <g:link class="display-inline" controller="search" action="inlineSearch"
                params="[s_controllerName: controllerName, s_actionName: actionName, objectUUID: params.id, max: params.max, offset: params.activeTab == 'packages' ? params.offset : '', sort: params.sort, order: params.order, qbe: 'g:packages', refOID: d.getOID(), inline: true, qp_provider_id: d.id, hide: ['qp_provider', 'qp_provider_id'], activeTab: 'packages', jumpOffset: params.activeTab == 'packages' ? params.jumpOffset : '']"
                id="">Packages on this Platform</g:link>
    </semui:tabsItemContent>

</g:if>