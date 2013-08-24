{* purpose of this template: metatags view view in admin area *}
<div class="museo-metatag museo-view">
{include file='admin/header.tpl'}
{gt text='Metatag list' assign='templateTitle'}
{pagesetvar name='title' value=$templateTitle}
<div class="z-admin-content-pagetitle">
    {icon type='view' size='small' alt=$templateTitle}
    <h3>{$templateTitle}</h3>
</div>


    {checkpermissionblock component='MUSeo::' instance='.*' level="ACCESS_ADD"}
        {gt text='Create metatag' assign='createTitle'}
        <a href="{modurl modname='MUSeo' type='admin' func='edit' ot='metatag'}" title="{$createTitle}" class="z-icon-es-add">
            {$createTitle}
        </a>
    {/checkpermissionblock}

    {assign var='all' value=0}
    {if isset($showAllEntries) && $showAllEntries eq 1}
        {gt text='Back to paginated view' assign='linkTitle'}
        <a href="{modurl modname='MUSeo' type='admin' func='view' ot='metatag'}" title="{$linkTitle}" class="z-icon-es-view">
            {$linkTitle}
        </a>
        {assign var='all' value=1}
    {else}
        {gt text='Show all entries' assign='linkTitle'}
        <a href="{modurl modname='MUSeo' type='admin' func='view' ot='metatag' all=1}" title="{$linkTitle}" class="z-icon-es-view">
            {$linkTitle}
        </a>
    {/if}

<table class="z-datatable">
    <colgroup>
        <col id="ctitleofentity" />
        <col id="ctitle" />
        <col id="cdescription" />
        <col id="ckeywords" />
        <col id="crobots" />
        <col id="cthemodule" />
        <col id="cfunctionofmodule" />
        <col id="cobjectofmodule" />
        <col id="cnameofidentifier" />
        <col id="cidofobject" />
        <col id="cstringofobject" />
       {* <col id="cextrainfos" /> *}
        <col id="citemactions" />
    </colgroup>
    <thead>
    <tr>
        <th id="htitleofentity" scope="col" class="z-left">
            {sortlink __linktext='Title of entity' sort='titleOfEntity' currentsort=$sort sortdir=$sdir all=$all modname='MUSeo' type='admin' func='view' ot='metatag'}
        </th>
        <th id="htitle" scope="col" class="z-left">
            {sortlink __linktext='Title' sort='title' currentsort=$sort sortdir=$sdir all=$all modname='MUSeo' type='admin' func='view' ot='metatag'}
        </th>
        <th id="hdescription" scope="col" class="z-left">
            {sortlink __linktext='Description' sort='description' currentsort=$sort sortdir=$sdir all=$all modname='MUSeo' type='admin' func='view' ot='metatag'}
        </th>
        <th id="hkeywords" scope="col" class="z-left">
            {sortlink __linktext='Keywords' sort='keywords' currentsort=$sort sortdir=$sdir all=$all modname='MUSeo' type='admin' func='view' ot='metatag'}
        </th>
        <th id="hrobots" scope="col" class="z-left">
            {gt text='Robots'}
        </th>
        <th id="hthemodule" scope="col" class="z-left">
            {sortlink __linktext='The module' sort='theModule' currentsort=$sort sortdir=$sdir all=$all modname='MUSeo' type='admin' func='view' ot='metatag'}
        </th>
        <th id="hfunctionofmodule" scope="col" class="z-left">
            {sortlink __linktext='Function of module' sort='functionOfModule' currentsort=$sort sortdir=$sdir all=$all modname='MUSeo' type='admin' func='view' ot='metatag'}
        </th>
        <th id="hobjectofmodule" scope="col" class="z-left">
            {sortlink __linktext='Object of module' sort='objectOfModule' currentsort=$sort sortdir=$sdir all=$all modname='MUSeo' type='admin' func='view' ot='metatag'}
        </th>
        <th id="hnameofidentifier" scope="col" class="z-left">
            {sortlink __linktext='Name of identifier' sort='nameOfIdentifier' currentsort=$sort sortdir=$sdir all=$all modname='MUSeo' type='admin' func='view' ot='metatag'}
        </th>
        <th id="hidofobject" scope="col" class="z-right">
            {sortlink __linktext='Id of object' sort='idOfObject' currentsort=$sort sortdir=$sdir all=$all modname='MUSeo' type='admin' func='view' ot='metatag'}
        </th>
        <th id="hstringofobject" scope="col" class="z-left">
            {sortlink __linktext='String of object' sort='stringOfObject' currentsort=$sort sortdir=$sdir all=$all modname='MUSeo' type='admin' func='view' ot='metatag'}
        </th>
       {* <th id="hextrainfos" scope="col" class="z-left">
            {sortlink __linktext='Extra infos' sort='extraInfos' currentsort=$sort sortdir=$sdir all=$all modname='MUSeo' type='admin' func='view' ot='metatag'}
        </th> *}
        <th id="hitemactions" scope="col" class="z-right z-order-unsorted">{gt text='Actions'}</th>
    </tr>
    </thead>
    <tbody>

    {foreach item='metatag' from=$items}
    <tr class="{cycle values='z-odd, z-even'}">
        <td headers="htitleofentity" class="z-left">
            {$metatag.titleOfEntity|notifyfilters:'museo.filterhook.metatags'}
        </td>
        <td headers="htitle" class="z-left">
            {$metatag.title}
        </td>
        <td headers="hdescription" class="z-left">
            {$metatag.description}
        </td>
        <td headers="hkeywords" class="z-left">
            {$metatag.keywords}
        </td>
        <td headers="hrobots" class="z-left">
            {$metatag.robots}
        </td>
        <td headers="hthemodule" class="z-left">
            {$metatag.theModule}
        </td>
        <td headers="hfunctionofmodule" class="z-left">
            {$metatag.functionOfModule}
        </td>
        <td headers="hobjectofmodule" class="z-left">
            {$metatag.objectOfModule}
        </td>
        <td headers="hnameofidentifier" class="z-left">
            {$metatag.nameOfIdentifier}
        </td>
        <td headers="hidofobject" class="z-right">
            {$metatag.idOfObject}
        </td>
        <td headers="hstringofobject" class="z-left">
            {$metatag.stringOfObject}
        </td>
       {* <td headers="hextrainfos" class="z-left">
            {$metatag.extraInfos}
        </td> *}
        <td headers="hitemactions" class="z-right z-nowrap z-w02">
            {if count($metatag._actions) gt 0}
            {strip}
                {foreach item='option' from=$metatag._actions}
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
          <td class="z-left" colspan="12">
            {gt text='No metatags found.'}
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

