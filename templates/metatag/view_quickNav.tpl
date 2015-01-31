{* purpose of this template: metatags view filter form *}
{checkpermissionblock component='MUSeo:Metatag:' instance='::' level='ACCESS_EDIT'}
{assign var='objectType' value='metatag'}
<form action="{$modvars.ZConfig.entrypoint|default:'index.php'}" method="get" id="mUSeoMetatagQuickNavForm" class="museo-quicknav">
    <fieldset>
        <h3>{gt text='Quick navigation'}</h3>
        <input type="hidden" name="module" value="{modgetinfo modname='MUSeo' info='url'}" />
        <input type="hidden" name="type" value="{$lct}" />
        <input type="hidden" name="ot" value="metatag" />
        <input type="hidden" name="func" value="view" />
        <input type="hidden" name="all" value="{$all|default:0}" />
        <input type="hidden" name="own" value="{$own|default:0}" />
        {gt text='All' assign='lblDefault'}
        {if !isset($workflowStateFilter) || $workflowStateFilter eq true}
                <label for="workflowState">{gt text='Workflow state'}</label>
                <select id="workflowState" name="workflowState">
                    <option value="">{$lblDefault}</option>
                {foreach item='option' from=$workflowStateItems}
                <option value="{$option.value}"{if $option.title ne ''} title="{$option.title|safetext}"{/if}{if $option.value eq $workflowState} selected="selected"{/if}>{$option.text|safetext}</option>
                {/foreach}
                </select>
        {/if}
        {if !isset($robotsIndexFilter) || $robotsIndexFilter eq true}
                <label for="robotsIndex">{gt text='Robots index'}</label>
                <select id="robotsIndex" name="robotsIndex">
                    <option value="">{$lblDefault}</option>
                {foreach item='option' from=$robotsIndexItems}
                <option value="{$option.value}"{if $option.title ne ''} title="{$option.title|safetext}"{/if}{if $option.value eq $robotsIndex} selected="selected"{/if}>{$option.text|safetext}</option>
                {/foreach}
                </select>
        {/if}
        {if !isset($robotsFollowFilter) || $robotsFollowFilter eq true}
                <label for="robotsFollow">{gt text='Robots follow'}</label>
                <select id="robotsFollow" name="robotsFollow">
                    <option value="">{$lblDefault}</option>
                {foreach item='option' from=$robotsFollowItems}
                <option value="{$option.value}"{if $option.title ne ''} title="{$option.title|safetext}"{/if}{if $option.value eq $robotsFollow} selected="selected"{/if}>{$option.text|safetext}</option>
                {/foreach}
                </select>
        {/if}
        {if !isset($robotsAdvancedFilter) || $robotsAdvancedFilter eq true}
                <label for="robotsAdvanced">{gt text='Robots advanced'}</label>
                <select id="robotsAdvanced" name="robotsAdvanced">
                    <option value="">{$lblDefault}</option>
                {foreach item='option' from=$robotsAdvancedItems}
                <option value="%{$option.value}"{if $option.title ne ''} title="{$option.title|safetext}"{/if}{if "%`$option.value`" eq $formats} selected="selected"{/if}>{$option.text|safetext}</option>
                {/foreach}
                </select>
        {/if}
        {if !isset($searchFilter) || $searchFilter eq true}
                <label for="searchTerm">{gt text='Search'}</label>
                <input type="text" id="searchTerm" name="q" value="{$q}" />
        {/if}
        {if !isset($sorting) || $sorting eq true}
                <label for="sortBy">{gt text='Sort by'}</label>
                &nbsp;
                <select id="sortBy" name="sort">
                    <option value="id"{if $sort eq 'id'} selected="selected"{/if}>{gt text='Id'}</option>
                    <option value="titleOfEntity"{if $sort eq 'titleOfEntity'} selected="selected"{/if}>{gt text='Title of entity'}</option>
                    <option value="focusKeyword"{if $sort eq 'focusKeyword'} selected="selected"{/if}>{gt text='Focus keyword'}</option>
                    <option value="title"{if $sort eq 'title'} selected="selected"{/if}>{gt text='Title'}</option>
                    <option value="description"{if $sort eq 'description'} selected="selected"{/if}>{gt text='Description'}</option>
                    <option value="keywords"{if $sort eq 'keywords'} selected="selected"{/if}>{gt text='Keywords'}</option>
                    <option value="robotsIndex"{if $sort eq 'robotsIndex'} selected="selected"{/if}>{gt text='Robots index'}</option>
                    <option value="robotsFollow"{if $sort eq 'robotsFollow'} selected="selected"{/if}>{gt text='Robots follow'}</option>
                    <option value="robotsAdvanced"{if $sort eq 'robotsAdvanced'} selected="selected"{/if}>{gt text='Robots advanced'}</option>
                    <option value="canonicalUrl"{if $sort eq 'canonicalUrl'} selected="selected"{/if}>{gt text='Canonical url'}</option>
                    <option value="redirectUrl"{if $sort eq 'redirectUrl'} selected="selected"{/if}>{gt text='Redirect url'}</option>
                    <option value="facebookTitle"{if $sort eq 'facebookTitle'} selected="selected"{/if}>{gt text='Facebook title'}</option>
                    <option value="facebookDescription"{if $sort eq 'facebookDescription'} selected="selected"{/if}>{gt text='Facebook description'}</option>
                    <option value="facebookImage"{if $sort eq 'facebookImage'} selected="selected"{/if}>{gt text='Facebook image'}</option>
                    <option value="twitterTitle"{if $sort eq 'twitterTitle'} selected="selected"{/if}>{gt text='Twitter title'}</option>
                    <option value="twitterDescription"{if $sort eq 'twitterDescription'} selected="selected"{/if}>{gt text='Twitter description'}</option>
                    <option value="twitterImage"{if $sort eq 'twitterImage'} selected="selected"{/if}>{gt text='Twitter image'}</option>
                    <option value="googlePlusTitle"{if $sort eq 'googlePlusTitle'} selected="selected"{/if}>{gt text='Google plus title'}</option>
                    <option value="googlePlusDescription"{if $sort eq 'googlePlusDescription'} selected="selected"{/if}>{gt text='Google plus description'}</option>
                    <option value="googlePlusImage"{if $sort eq 'googlePlusImage'} selected="selected"{/if}>{gt text='Google plus image'}</option>
                    <option value="pageAnalysisScore"{if $sort eq 'pageAnalysisScore'} selected="selected"{/if}>{gt text='Page analysis score'}</option>
                    <option value="theModule"{if $sort eq 'theModule'} selected="selected"{/if}>{gt text='The module'}</option>
                    <option value="functionOfModule"{if $sort eq 'functionOfModule'} selected="selected"{/if}>{gt text='Function of module'}</option>
                    <option value="objectOfModule"{if $sort eq 'objectOfModule'} selected="selected"{/if}>{gt text='Object of module'}</option>
                    <option value="nameOfIdentifier"{if $sort eq 'nameOfIdentifier'} selected="selected"{/if}>{gt text='Name of identifier'}</option>
                    <option value="idOfObject"{if $sort eq 'idOfObject'} selected="selected"{/if}>{gt text='Id of object'}</option>
                    <option value="stringOfObject"{if $sort eq 'stringOfObject'} selected="selected"{/if}>{gt text='String of object'}</option>
                    <option value="extraInfos"{if $sort eq 'extraInfos'} selected="selected"{/if}>{gt text='Extra infos'}</option>
                    <option value="createdDate"{if $sort eq 'createdDate'} selected="selected"{/if}>{gt text='Creation date'}</option>
                    <option value="createdUserId"{if $sort eq 'createdUserId'} selected="selected"{/if}>{gt text='Creator'}</option>
                    <option value="updatedDate"{if $sort eq 'updatedDate'} selected="selected"{/if}>{gt text='Update date'}</option>
                </select>
                <select id="sortDir" name="sortdir">
                    <option value="asc"{if $sdir eq 'asc'} selected="selected"{/if}>{gt text='ascending'}</option>
                    <option value="desc"{if $sdir eq 'desc'} selected="selected"{/if}>{gt text='descending'}</option>
                </select>
        {else}
            <input type="hidden" name="sort" value="{$sort}" />
            <input type="hidden" name="sdir" value="{if $sdir eq 'desc'}asc{else}desc{/if}" />
        {/if}
        {if !isset($pageSizeSelector) || $pageSizeSelector eq true}
                <label for="num">{gt text='Page size'}</label>
                <select id="num" name="num">
                    <option value="5"{if $pageSize eq 5} selected="selected"{/if}>5</option>
                    <option value="10"{if $pageSize eq 10} selected="selected"{/if}>10</option>
                    <option value="15"{if $pageSize eq 15} selected="selected"{/if}>15</option>
                    <option value="20"{if $pageSize eq 20} selected="selected"{/if}>20</option>
                    <option value="30"{if $pageSize eq 30} selected="selected"{/if}>30</option>
                    <option value="50"{if $pageSize eq 50} selected="selected"{/if}>50</option>
                    <option value="100"{if $pageSize eq 100} selected="selected"{/if}>100</option>
                </select>
        {/if}
        <input type="submit" name="updateview" id="quicknavSubmit" value="{gt text='OK'}" />
    </fieldset>
</form>

<script type="text/javascript">
/* <![CDATA[ */
    document.observe('dom:loaded', function() {
        mUMUSeoInitQuickNavigation('metatag');
        {{if isset($searchFilter) && $searchFilter eq false}}
            {{* we can hide the submit button if we have no quick search field *}}
            $('quicknavSubmit').addClassName('z-hide');
        {{/if}}
    });
/* ]]> */
</script>
{/checkpermissionblock}
