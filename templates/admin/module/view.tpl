{* purpose of this template: modules view view in admin area *}
<div class="museo-module museo-view">
{include file='admin/header.tpl'}
{gt text='Module list' assign='templateTitle'}
{pagesetvar name='title' value=$templateTitle}
<div class="z-admin-content-pagetitle">
    {icon type='view' size='small' alt=$templateTitle}
    <h3>{$templateTitle}</h3>
</div>


    {checkpermissionblock component='MUSeo::' instance='.*' level="ACCESS_ADD"}
        {gt text='Create module' assign='createTitle'}
        <a href="{modurl modname='MUSeo' type='admin' func='edit' ot='module'}" title="{$createTitle}" class="z-icon-es-add">
            {$createTitle}
        </a>
    {/checkpermissionblock}

    {assign var='all' value=0}
    {if isset($showAllEntries) && $showAllEntries eq 1}
        {gt text='Back to paginated view' assign='linkTitle'}
        <a href="{modurl modname='MUSeo' type='admin' func='view' ot='module'}" title="{$linkTitle}" class="z-icon-es-view">
            {$linkTitle}
        </a>
        {assign var='all' value=1}
    {else}
        {gt text='Show all entries' assign='linkTitle'}
        <a href="{modurl modname='MUSeo' type='admin' func='view' ot='module' all=1}" title="{$linkTitle}" class="z-icon-es-view">
            {$linkTitle}
        </a>
    {/if}

<table class="z-datatable">
    <colgroup>
        <col id="cname" />
        <col id="ccontrollerforview" />
        <col id="ccontrollerforsingleobject" />
        <col id="cparameterforobjects" />
        <col id="cnameofidentifier" />
        <col id="cextraidentifier" />
        <col id="citemactions" />
    </colgroup>
    <thead>
    <tr>
        <th id="hname" scope="col" class="z-left">
            {sortlink __linktext='Name' sort='name' currentsort=$sort sortdir=$sdir all=$all modname='MUSeo' type='admin' func='view' ot='module'}
        </th>
        <th id="hcontrollerforview" scope="col" class="z-left">
            {sortlink __linktext='Controller for view' sort='controllerForView' currentsort=$sort sortdir=$sdir all=$all modname='MUSeo' type='admin' func='view' ot='module'}
        </th>
        <th id="hcontrollerforsingleobject" scope="col" class="z-left">
            {sortlink __linktext='Controller for single object' sort='controllerForSingleObject' currentsort=$sort sortdir=$sdir all=$all modname='MUSeo' type='admin' func='view' ot='module'}
        </th>
        <th id="hparameterforobjects" scope="col" class="z-left">
            {sortlink __linktext='Parameter for objects' sort='parameterForObjects' currentsort=$sort sortdir=$sdir all=$all modname='MUSeo' type='admin' func='view' ot='module'}
        </th>
        <th id="hnameofidentifier" scope="col" class="z-left">
            {sortlink __linktext='Name of identifier' sort='nameOfIdentifier' currentsort=$sort sortdir=$sdir all=$all modname='MUSeo' type='admin' func='view' ot='module'}
        </th>
        <th id="hextraidentifier" scope="col" class="z-left">
            {sortlink __linktext='Extra identifier' sort='extraIdentifier' currentsort=$sort sortdir=$sdir all=$all modname='MUSeo' type='admin' func='view' ot='module'}
        </th>
        <th id="hitemactions" scope="col" class="z-right z-order-unsorted">{gt text='Actions'}</th>
    </tr>
    </thead>
    <tbody>

    {foreach item='module' from=$items}
    <tr class="{cycle values='z-odd, z-even'}">
        <td headers="hname" class="z-left">
            {$module.name|notifyfilters:'museo.filterhook.modules'}
        </td>
        <td headers="hcontrollerforview" class="z-left">
            {$module.controllerForView}
        </td>
        <td headers="hcontrollerforsingleobject" class="z-left">
            {$module.controllerForSingleObject}
        </td>
        <td headers="hparameterforobjects" class="z-left">
            {$module.parameterForObjects}
        </td>
        <td headers="hnameofidentifier" class="z-left">
            {$module.nameOfIdentifier}
        </td>
        <td headers="hextraidentifier" class="z-left">
            {$module.extraIdentifier}
        </td>
        <td headers="hitemactions" class="z-right z-nowrap z-w02">
            {if count($module._actions) gt 0}
            {strip}
                {foreach item='option' from=$module._actions}
                    <a href="{$option.url.type|museoActionUrl:$option.url.func:$option.url.arguments}" title="{$option.linkTitle|safetext}"{if $option.icon eq 'preview'} target="_blank"{/if}>
                        {icon type=$option.icon size='extrasmall' alt=$option.linkText|safetext}
                    </a>
                {/foreach}
            {/strip}
            {/if}
        </td>
    </tr>
    {foreachelse}
        <tr class="z-admintableempty">
          <td class="z-left" colspan="7">
            {gt text='No modules found.'}
          </td>
        </tr>
    {/foreach}

    </tbody>
</table>

    {if !isset($showAllEntries) || $showAllEntries ne 1}
        {pager rowcount=$pager.numitems limit=$pager.itemsperpage display='page'}
    {/if}
</div>
{include file='admin/footer.tpl'}

