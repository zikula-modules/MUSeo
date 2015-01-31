{* purpose of this template: metatags list view *}
{assign var='lct' value='user'}
{if isset($smarty.get.lct) && $smarty.get.lct eq 'admin'}
    {assign var='lct' value='admin'}
{/if}
{include file="`$lct`/header.tpl"}
<div class="museo-metatag museo-view">
    {gt text='Metatag list' assign='templateTitle'}
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
        {checkpermissionblock component='MUSeo:Metatag:' instance='::' level='ACCESS_EDIT'}
            {gt text='Create metatag' assign='createTitle'}
            <a href="{modurl modname='MUSeo' type=$lct func='edit' ot='metatag'}" title="{$createTitle}" class="z-icon-es-add">{$createTitle}</a>
        {/checkpermissionblock}
    {/if}
    {assign var='own' value=0}
    {if isset($showOwnEntries) && $showOwnEntries eq 1}
        {assign var='own' value=1}
    {/if}
    {assign var='all' value=0}
    {if isset($showAllEntries) && $showAllEntries eq 1}
        {gt text='Back to paginated view' assign='linkTitle'}
        <a href="{modurl modname='MUSeo' type=$lct func='view' ot='metatag'}" title="{$linkTitle}" class="z-icon-es-view">{$linkTitle}</a>
        {assign var='all' value=1}
    {else}
        {gt text='Show all entries' assign='linkTitle'}
        <a href="{modurl modname='MUSeo' type=$lct func='view' ot='metatag' all=1}" title="{$linkTitle}" class="z-icon-es-view">{$linkTitle}</a>
    {/if}

    {include file='metatag/view_quickNav.tpl' all=$all own=$own workflowStateFilter=false}{* see template file for available options *}

    {if $lct eq 'admin'}
    <form action="{modurl modname='MUSeo' type='metatag' func='handleSelectedEntries' lct=$lct}" method="post" id="metatagsViewForm" class="z-form">
        <div>
            <input type="hidden" name="csrftoken" value="{insert name='csrftoken'}" />
    {/if}
        <table class="z-datatable">
            <colgroup>
                {if $lct eq 'admin'}
                    <col id="cSelect" />
                {/if}
                <col id="cTitleOfEntity" />
                <col id="cFocusKeyword" />
                <col id="cTitle" />
                <col id="cDescription" />
                <col id="cKeywords" />
{*              <col id="cFacebookTitle" />
                <col id="cFacebookDescription" />
                <col id="cFacebookImage" />
                <col id="cTwitterTitle" />
                <col id="cTwitterDescription" />
                <col id="cTwitterImage" />
                <col id="cGooglePlusTitle" />
                <col id="cGooglePlusDescription" />
                <col id="cGooglePlusImage" />*}
                <col id="cPageAnalysisScore" />
                <col id="cItemActions" />
            </colgroup>
            <thead>
            <tr>
                {if $lct eq 'admin'}
                    <th id="hSelect" scope="col" align="center" valign="middle">
                        <input type="checkbox" id="toggleMetatags" />
                    </th>
                {/if}
                <th id="hTitleOfEntity" scope="col" class="z-left">
                    {sortlink __linktext='Title of entity' currentsort=$sort modname='MUSeo' type=$lct func='view' sort='titleOfEntity' sortdir=$sdir all=$all own=$own workflowState=$workflowState robotsIndex=$robotsIndex robotsFollow=$robotsFollow robotsAdvanced=$robotsAdvanced q=$q pageSize=$pageSize ot='metatag'}
                </th>
                <th id="hFocusKeyword" scope="col" class="z-left">
                    {sortlink __linktext='Focus keyword' currentsort=$sort modname='MUSeo' type=$lct func='view' sort='focusKeyword' sortdir=$sdir all=$all own=$own workflowState=$workflowState robotsIndex=$robotsIndex robotsFollow=$robotsFollow robotsAdvanced=$robotsAdvanced q=$q pageSize=$pageSize ot='metatag'}
                </th>
                <th id="hTitle" scope="col" class="z-left">
                    {sortlink __linktext='Title' currentsort=$sort modname='MUSeo' type=$lct func='view' sort='title' sortdir=$sdir all=$all own=$own workflowState=$workflowState robotsIndex=$robotsIndex robotsFollow=$robotsFollow robotsAdvanced=$robotsAdvanced q=$q pageSize=$pageSize ot='metatag'}
                </th>
                <th id="hDescription" scope="col" class="z-left">
                    {sortlink __linktext='Description' currentsort=$sort modname='MUSeo' type=$lct func='view' sort='description' sortdir=$sdir all=$all own=$own workflowState=$workflowState robotsIndex=$robotsIndex robotsFollow=$robotsFollow robotsAdvanced=$robotsAdvanced q=$q pageSize=$pageSize ot='metatag'}
                </th>
                <th id="hKeywords" scope="col" class="z-left">
                    {sortlink __linktext='Keywords' currentsort=$sort modname='MUSeo' type=$lct func='view' sort='keywords' sortdir=$sdir all=$all own=$own workflowState=$workflowState robotsIndex=$robotsIndex robotsFollow=$robotsFollow robotsAdvanced=$robotsAdvanced q=$q pageSize=$pageSize ot='metatag'}
                </th>
{*                <th id="hFacebookTitle" scope="col" class="z-left">
                    {sortlink __linktext='Facebook title' currentsort=$sort modname='MUSeo' type=$lct func='view' sort='facebookTitle' sortdir=$sdir all=$all own=$own workflowState=$workflowState robotsIndex=$robotsIndex robotsFollow=$robotsFollow robotsAdvanced=$robotsAdvanced q=$q pageSize=$pageSize ot='metatag'}
                </th>
                <th id="hFacebookDescription" scope="col" class="z-left">
                    {sortlink __linktext='Facebook description' currentsort=$sort modname='MUSeo' type=$lct func='view' sort='facebookDescription' sortdir=$sdir all=$all own=$own workflowState=$workflowState robotsIndex=$robotsIndex robotsFollow=$robotsFollow robotsAdvanced=$robotsAdvanced q=$q pageSize=$pageSize ot='metatag'}
                </th>
                <th id="hFacebookImage" scope="col" class="z-left">
                    {sortlink __linktext='Facebook image' currentsort=$sort modname='MUSeo' type=$lct func='view' sort='facebookImage' sortdir=$sdir all=$all own=$own workflowState=$workflowState robotsIndex=$robotsIndex robotsFollow=$robotsFollow robotsAdvanced=$robotsAdvanced q=$q pageSize=$pageSize ot='metatag'}
                </th>
                <th id="hTwitterTitle" scope="col" class="z-left">
                    {sortlink __linktext='Twitter title' currentsort=$sort modname='MUSeo' type=$lct func='view' sort='twitterTitle' sortdir=$sdir all=$all own=$own workflowState=$workflowState robotsIndex=$robotsIndex robotsFollow=$robotsFollow robotsAdvanced=$robotsAdvanced q=$q pageSize=$pageSize ot='metatag'}
                </th>
                <th id="hTwitterDescription" scope="col" class="z-left">
                    {sortlink __linktext='Twitter description' currentsort=$sort modname='MUSeo' type=$lct func='view' sort='twitterDescription' sortdir=$sdir all=$all own=$own workflowState=$workflowState robotsIndex=$robotsIndex robotsFollow=$robotsFollow robotsAdvanced=$robotsAdvanced q=$q pageSize=$pageSize ot='metatag'}
                </th>
                <th id="hTwitterImage" scope="col" class="z-left">
                    {sortlink __linktext='Twitter image' currentsort=$sort modname='MUSeo' type=$lct func='view' sort='twitterImage' sortdir=$sdir all=$all own=$own workflowState=$workflowState robotsIndex=$robotsIndex robotsFollow=$robotsFollow robotsAdvanced=$robotsAdvanced q=$q pageSize=$pageSize ot='metatag'}
                </th>
                <th id="hGooglePlusTitle" scope="col" class="z-left">
                    {sortlink __linktext='Google plus title' currentsort=$sort modname='MUSeo' type=$lct func='view' sort='googlePlusTitle' sortdir=$sdir all=$all own=$own workflowState=$workflowState robotsIndex=$robotsIndex robotsFollow=$robotsFollow robotsAdvanced=$robotsAdvanced q=$q pageSize=$pageSize ot='metatag'}
                </th>
                <th id="hGooglePlusDescription" scope="col" class="z-left">
                    {sortlink __linktext='Google plus description' currentsort=$sort modname='MUSeo' type=$lct func='view' sort='googlePlusDescription' sortdir=$sdir all=$all own=$own workflowState=$workflowState robotsIndex=$robotsIndex robotsFollow=$robotsFollow robotsAdvanced=$robotsAdvanced q=$q pageSize=$pageSize ot='metatag'}
                </th>
                <th id="hGooglePlusImage" scope="col" class="z-left">
                    {sortlink __linktext='Google plus image' currentsort=$sort modname='MUSeo' type=$lct func='view' sort='googlePlusImage' sortdir=$sdir all=$all own=$own workflowState=$workflowState robotsIndex=$robotsIndex robotsFollow=$robotsFollow robotsAdvanced=$robotsAdvanced q=$q pageSize=$pageSize ot='metatag'}
                </th>*}
                <th id="hPageAnalysisScore" scope="col" class="z-right">
                    {sortlink __linktext='Page analysis score' currentsort=$sort modname='MUSeo' type=$lct func='view' sort='pageAnalysisScore' sortdir=$sdir all=$all own=$own workflowState=$workflowState robotsIndex=$robotsIndex robotsFollow=$robotsFollow robotsAdvanced=$robotsAdvanced q=$q pageSize=$pageSize ot='metatag'}
                </th>
                <th id="hItemActions" scope="col" class="z-right z-order-unsorted">{gt text='Actions'}</th>
            </tr>
            </thead>
            <tbody>
        
        {foreach item='metatag' from=$items}
            <tr class="{cycle values='z-odd, z-even'}">
                {if $lct eq 'admin'}
                    <td headers="hselect" align="center" valign="top">
                        <input type="checkbox" name="items[]" value="{$metatag.id}" class="metatags-checkbox" />
                    </td>
                {/if}
                <td headers="hTitleOfEntity" class="z-left">
                    {$metatag.titleOfEntity}
                </td>
                <td headers="hFocusKeyword" class="z-left">
                    {$metatag.focusKeyword}
                </td>
                <td headers="hTitle" class="z-left">
                    <a href="{modurl modname='MUSeo' type=$lct func='display' ot='metatag'  id=$metatag.id}" title="{gt text='View detail page'}">{$metatag.title|notifyfilters:'museo.filterhook.metatags'}</a>
                </td>
                <td headers="hDescription" class="z-left">
                    {$metatag.description}
                </td>
                <td headers="hKeywords" class="z-left">
                    {$metatag.keywords}
                </td>
{*                <td headers="hFacebookTitle" class="z-left">
                    {$metatag.facebookTitle}
                </td>
                <td headers="hFacebookDescription" class="z-left">
                    {$metatag.facebookDescription}
                </td>
                <td headers="hFacebookImage" class="z-left">
                    {if $metatag.facebookImage ne ''}
                      <a href="{$metatag.facebookImageFullPathURL}" title="{$metatag->getTitleFromDisplayPattern()|replace:"\"":""}"{if $metatag.facebookImageMeta.isImage} rel="imageviewer[metatag]"{/if}>
                      {if $metatag.facebookImageMeta.isImage}
                          {thumb image=$metatag.facebookImageFullPath objectid="metatag-`$metatag.id`" preset=$metatagThumbPresetFacebookImage tag=true img_alt=$metatag->getTitleFromDisplayPattern()}
                      {else}
                          {gt text='Download'} ({$metatag.facebookImageMeta.size|museoGetFileSize:$metatag.facebookImageFullPath:false:false})
                      {/if}
                      </a>
                    {else}&nbsp;{/if}
                </td>
                <td headers="hTwitterTitle" class="z-left">
                    {$metatag.twitterTitle}
                </td>
                <td headers="hTwitterDescription" class="z-left">
                    {$metatag.twitterDescription}
                </td>
                <td headers="hTwitterImage" class="z-left">
                    {if $metatag.twitterImage ne ''}
                      <a href="{$metatag.twitterImageFullPathURL}" title="{$metatag->getTitleFromDisplayPattern()|replace:"\"":""}"{if $metatag.twitterImageMeta.isImage} rel="imageviewer[metatag]"{/if}>
                      {if $metatag.twitterImageMeta.isImage}
                          {thumb image=$metatag.twitterImageFullPath objectid="metatag-`$metatag.id`" preset=$metatagThumbPresetTwitterImage tag=true img_alt=$metatag->getTitleFromDisplayPattern()}
                      {else}
                          {gt text='Download'} ({$metatag.twitterImageMeta.size|museoGetFileSize:$metatag.twitterImageFullPath:false:false})
                      {/if}
                      </a>
                    {else}&nbsp;{/if}
                </td>
                <td headers="hGooglePlusTitle" class="z-left">
                    {$metatag.googlePlusTitle}
                </td>
                <td headers="hGooglePlusDescription" class="z-left">
                    {$metatag.googlePlusDescription}
                </td>
                <td headers="hGooglePlusImage" class="z-left">
                    {if $metatag.googlePlusImage ne ''}
                      <a href="{$metatag.googlePlusImageFullPathURL}" title="{$metatag->getTitleFromDisplayPattern()|replace:"\"":""}"{if $metatag.googlePlusImageMeta.isImage} rel="imageviewer[metatag]"{/if}>
                      {if $metatag.googlePlusImageMeta.isImage}
                          {thumb image=$metatag.googlePlusImageFullPath objectid="metatag-`$metatag.id`" preset=$metatagThumbPresetGooglePlusImage tag=true img_alt=$metatag->getTitleFromDisplayPattern()}
                      {else}
                          {gt text='Download'} ({$metatag.googlePlusImageMeta.size|museoGetFileSize:$metatag.googlePlusImageFullPath:false:false})
                      {/if}
                      </a>
                    {else}&nbsp;{/if}
                </td>*}
                <td headers="hPageAnalysisScore" class="z-right">
                    {$metatag.pageAnalysisScore}
                </td>
                <td id="itemActions{$metatag.id}" headers="hItemActions" class="z-right z-nowrap z-w02">
                    {if count($metatag._actions) gt 0}
                        {icon id="itemActions`$metatag.id`Trigger" type='options' size='extrasmall' __alt='Actions' class='z-pointer z-hide'}
                        {foreach item='option' from=$metatag._actions}
                            <a href="{$option.url.type|museoActionUrl:$option.url.func:$option.url.arguments}" title="{$option.linkTitle|safetext}"{if $option.icon eq 'preview'} target="_blank"{/if}>{icon type=$option.icon size='extrasmall' alt=$option.linkText|safetext}</a>
                        {/foreach}
                        <script type="text/javascript">
                        /* <![CDATA[ */
                            document.observe('dom:loaded', function() {
                                mUMUSeoInitItemActions('metatag', 'view', 'itemActions{{$metatag.id}}');
                            });
                        /* ]]> */
                        </script>
                    {/if}
                </td>
            </tr>
        {foreachelse}
            <tr class="z-{if $lct eq 'admin'}admin{else}data{/if}tableempty">
              <td class="z-left" colspan="{if $lct eq 'admin'}8{else}7{/if}">
            {gt text='No metatags found.'}
              </td>
            </tr>
        {/foreach}
        
            </tbody>
        </table>
        
        {if !isset($showAllEntries) || $showAllEntries ne 1}
            {pager rowcount=$pager.numitems limit=$pager.itemsperpage display='page' modname='MUSeo' type=$lct func='view' ot='metatag'}
        {/if}
    {if $lct eq 'admin'}
            <fieldset>
                <label for="mUSeoAction">{gt text='With selected metatags'}</label>
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
        {notifydisplayhooks eventname='museo.ui_hooks.metatags.display_view' urlobject=$currentUrlObject assign='hooks'}
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
            if ($('toggleMetatags') != undefined) {
                $('toggleMetatags').observe('click', function (e) {
                    Zikula.toggleInput('metatagsViewForm');
                    e.stop()
                });
            }
        {{/if}}
    });
/* ]]> */
</script>
