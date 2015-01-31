{* purpose of this template: extensions list view *}
{assign var='lct' value='user'}
{if isset($smarty.get.lct) && $smarty.get.lct eq 'admin'}
    {assign var='lct' value='admin'}
{/if}
{include file="`$lct`/header.tpl"}
<div class="museo-extension museo-view">
    {gt text='Extension list' assign='templateTitle'}
    {pagesetvar name='title' value=$templateTitle}
    {if $lct eq 'admin'}
        <div class="z-admin-content-pagetitle">
            {icon type='view' size='small' alt=$templateTitle}
            <h3>{$templateTitle}</h3>
        </div>
    {else}
        <h2>{$templateTitle}</h2>
    {/if}

    {if $canBeCreated}
        {checkpermissionblock component='MUSeo:Extension:' instance='::' level='ACCESS_EDIT'}
            {gt text='Create extension' assign='createTitle'}
            <a href="{modurl modname='MUSeo' type=$lct func='edit' ot='extension'}" title="{$createTitle}" class="z-icon-es-add">{$createTitle}</a>
        {/checkpermissionblock}
    {/if}
    {assign var='own' value=0}
    {if isset($showOwnEntries) && $showOwnEntries eq 1}
        {assign var='own' value=1}
    {/if}
    {assign var='all' value=0}
    {if isset($showAllEntries) && $showAllEntries eq 1}
        {gt text='Back to paginated view' assign='linkTitle'}
        <a href="{modurl modname='MUSeo' type=$lct func='view' ot='extension'}" title="{$linkTitle}" class="z-icon-es-view">{$linkTitle}</a>
        {assign var='all' value=1}
    {else}
        {gt text='Show all entries' assign='linkTitle'}
        <a href="{modurl modname='MUSeo' type=$lct func='view' ot='extension' all=1}" title="{$linkTitle}" class="z-icon-es-view">{$linkTitle}</a>
    {/if}

    {include file='extension/view_quickNav.tpl' all=$all own=$own workflowStateFilter=false}{* see template file for available options *}

    {if $lct eq 'admin'}
    <form action="{modurl modname='MUSeo' type='extension' func='handleSelectedEntries' lct=$lct}" method="post" id="extensionsViewForm" class="z-form">
        <div>
            <input type="hidden" name="csrftoken" value="{insert name='csrftoken'}" />
    {/if}
        <table class="z-datatable">
            <colgroup>
                {if $lct eq 'admin'}
                    <col id="cSelect" />
                {/if}
                <col id="cName" />
                <col id="cControllerForView" />
                <col id="cControllerForSingleObject" />
                <col id="cParameterForObjects" />
                <col id="cNameOfIdentifier" />
                <col id="cExtraIdentifier" />
                <col id="cItemActions" />
            </colgroup>
            <thead>
            <tr>
                {if $lct eq 'admin'}
                    <th id="hSelect" scope="col" align="center" valign="middle">
                        <input type="checkbox" id="toggleExtensions" />
                    </th>
                {/if}
                <th id="hName" scope="col" class="z-left">
                    {sortlink __linktext='Name' currentsort=$sort modname='MUSeo' type=$lct func='view' sort='name' sortdir=$sdir all=$all own=$own workflowState=$workflowState q=$q pageSize=$pageSize ot='extension'}
                </th>
                <th id="hControllerForView" scope="col" class="z-left">
                    {sortlink __linktext='Controller for view' currentsort=$sort modname='MUSeo' type=$lct func='view' sort='controllerForView' sortdir=$sdir all=$all own=$own workflowState=$workflowState q=$q pageSize=$pageSize ot='extension'}
                </th>
                <th id="hControllerForSingleObject" scope="col" class="z-left">
                    {sortlink __linktext='Controller for single object' currentsort=$sort modname='MUSeo' type=$lct func='view' sort='controllerForSingleObject' sortdir=$sdir all=$all own=$own workflowState=$workflowState q=$q pageSize=$pageSize ot='extension'}
                </th>
                <th id="hParameterForObjects" scope="col" class="z-left">
                    {sortlink __linktext='Parameter for objects' currentsort=$sort modname='MUSeo' type=$lct func='view' sort='parameterForObjects' sortdir=$sdir all=$all own=$own workflowState=$workflowState q=$q pageSize=$pageSize ot='extension'}
                </th>
                <th id="hNameOfIdentifier" scope="col" class="z-left">
                    {sortlink __linktext='Name of identifier' currentsort=$sort modname='MUSeo' type=$lct func='view' sort='nameOfIdentifier' sortdir=$sdir all=$all own=$own workflowState=$workflowState q=$q pageSize=$pageSize ot='extension'}
                </th>
                <th id="hExtraIdentifier" scope="col" class="z-left">
                    {sortlink __linktext='Extra identifier' currentsort=$sort modname='MUSeo' type=$lct func='view' sort='extraIdentifier' sortdir=$sdir all=$all own=$own workflowState=$workflowState q=$q pageSize=$pageSize ot='extension'}
                </th>
                <th id="hItemActions" scope="col" class="z-right z-order-unsorted">{gt text='Actions'}</th>
            </tr>
            </thead>
            <tbody>
        
        {foreach item='extension' from=$items}
            <tr class="{cycle values='z-odd, z-even'}">
                {if $lct eq 'admin'}
                    <td headers="hselect" align="center" valign="top">
                        <input type="checkbox" name="items[]" value="{$extension.id}" class="extensions-checkbox" />
                    </td>
                {/if}
                <td headers="hName" class="z-left">
                    {$extension.name|notifyfilters:'museo.filterhook.extensions'}
                </td>
                <td headers="hControllerForView" class="z-left">
                    {$extension.controllerForView}
                </td>
                <td headers="hControllerForSingleObject" class="z-left">
                    {$extension.controllerForSingleObject}
                </td>
                <td headers="hParameterForObjects" class="z-left">
                    {$extension.parameterForObjects}
                </td>
                <td headers="hNameOfIdentifier" class="z-left">
                    {$extension.nameOfIdentifier}
                </td>
                <td headers="hExtraIdentifier" class="z-left">
                    {$extension.extraIdentifier}
                </td>
                <td id="itemActions{$extension.id}" headers="hItemActions" class="z-right z-nowrap z-w02">
                    {if count($extension._actions) gt 0}
                        {icon id="itemActions`$extension.id`Trigger" type='options' size='extrasmall' __alt='Actions' class='z-pointer z-hide'}
                        {foreach item='option' from=$extension._actions}
                            <a href="{$option.url.type|museoActionUrl:$option.url.func:$option.url.arguments}" title="{$option.linkTitle|safetext}"{if $option.icon eq 'preview'} target="_blank"{/if}>{icon type=$option.icon size='extrasmall' alt=$option.linkText|safetext}</a>
                        {/foreach}
                        <script type="text/javascript">
                        /* <![CDATA[ */
                            document.observe('dom:loaded', function() {
                                mUMUSeoInitItemActions('extension', 'view', 'itemActions{{$extension.id}}');
                            });
                        /* ]]> */
                        </script>
                    {/if}
                </td>
            </tr>
        {foreachelse}
            <tr class="z-{if $lct eq 'admin'}admin{else}data{/if}tableempty">
              <td class="z-left" colspan="{if $lct eq 'admin'}8{else}7{/if}">
            {gt text='No extensions found.'}
              </td>
            </tr>
        {/foreach}
        
            </tbody>
        </table>
        
        {if !isset($showAllEntries) || $showAllEntries ne 1}
            {pager rowcount=$pager.numitems limit=$pager.itemsperpage display='page' modname='MUSeo' type=$lct func='view' ot='extension'}
        {/if}
    {if $lct eq 'admin'}
            <fieldset>
                <label for="mUSeoAction">{gt text='With selected extensions'}</label>
                <select id="mUSeoAction" name="action">
                    <option value="">{gt text='Choose action'}</option>
                    <option value="delete" title="{gt text='Delete content permanently.'}">{gt text='Delete'}</option>
                </select>
                <input type="submit" value="{gt text='Submit'}" />
            </fieldset>
        </div>
    </form>
    {/if}

    
    {* here you can activate calling display hooks for the view page if you need it *}
    {*if $lct ne 'admin'}
        {notifydisplayhooks eventname='museo.ui_hooks.extensions.display_view' urlobject=$currentUrlObject assign='hooks'}
        {foreach key='providerArea' item='hook' from=$hooks}
            {$hook}
        {/foreach}
    {/if*}
</div>
{include file="`$lct`/footer.tpl"}

<script type="text/javascript">
/* <![CDATA[ */
    document.observe('dom:loaded', function() {
        {{if $lct eq 'admin'}}
            {{* init the "toggle all" functionality *}}
            if ($('toggleExtensions') != undefined) {
                $('toggleExtensions').observe('click', function (e) {
                    Zikula.toggleInput('extensionsViewForm');
                    e.stop()
                });
            }
        {{/if}}
    });
/* ]]> */
</script>
