{* purpose of this template: metatags display view *}
{assign var='lct' value='user'}
{if isset($smarty.get.lct) && $smarty.get.lct eq 'admin'}
    {assign var='lct' value='admin'}
{/if}
{include file="`$lct`/header.tpl"}
<div class="museo-metatag museo-display">
    {gt text='Metatag' assign='templateTitle'}
    {assign var='templateTitle' value=$metatag->getTitleFromDisplayPattern()|default:$templateTitle}
    {pagesetvar name='title' value=$templateTitle|@html_entity_decode}
    {if $lct eq 'admin'}
        <div class="z-admin-content-pagetitle">
            {icon type='display' size='small' __alt='Details'}
            <h3>{$templateTitle|notifyfilters:'museo.filter_hooks.metatags.filter'}{icon id="itemActions`$metatag.id`Trigger" type='options' size='extrasmall' __alt='Actions' class='z-pointer z-hide'}
            </h3>
        </div>
    {else}
        <h2>{$templateTitle|notifyfilters:'museo.filter_hooks.metatags.filter'}{icon id="itemActions`$metatag.id`Trigger" type='options' size='extrasmall' __alt='Actions' class='z-pointer z-hide'}
        </h2>
    {/if}

    <h4>{gt text="General"}</h4>
    <dl>
        <dt>{gt text='Title of entity'}</dt>
        <dd>{$metatag.titleOfEntity}</dd>
        <dt>{gt text='Focus keyword'}</dt>
        <dd>{$metatag.focusKeyword}</dd>
        <dt>{gt text='Title'}</dt>
        <dd>{$metatag.title}</dd>
        <dt>{gt text='Description'}</dt>
        <dd>{$metatag.description}</dd>
        <dt>{gt text='Keywords'}</dt>
        <dd>{$metatag.keywords}</dd>
     </dl>
    <h4>{gt text="Advanced"}</h4>
     <dl>
        <dt>{gt text='Robots index'}</dt>
        <dd>{$metatag.robotsIndex|museoGetListEntry:'metatag':'robotsIndex'|safetext}</dd>
        <dt>{gt text='Robots follow'}</dt>
        <dd>{$metatag.robotsFollow|museoGetListEntry:'metatag':'robotsFollow'|safetext}</dd>
        <dt>{gt text='Robots advanced'}</dt>
        <dd>{$metatag.robotsAdvanced|museoGetListEntry:'metatag':'robotsAdvanced'|safetext}</dd>
        <dt>{gt text='Canonical url'}</dt>
        <dd>{if $metatag.canonicalUrl ne ''}
        {if !isset($smarty.get.theme) || $smarty.get.theme ne 'Printer'}
        <a href="{$metatag.canonicalUrl}" title="{gt text='Visit this page'}">{icon type='url' size='extrasmall' __alt='Homepage'}</a>
        {else}
          {$metatag.canonicalUrl}
        {/if}
        {else}&nbsp;{/if}
        </dd>
        <dt>{gt text='Redirect url'}</dt>
        <dd>{if $metatag.redirectUrl ne ''}
        {if !isset($smarty.get.theme) || $smarty.get.theme ne 'Printer'}
        <a href="{$metatag.redirectUrl}" title="{gt text='Visit this page'}">{icon type='url' size='extrasmall' __alt='Homepage'}</a>
        {else}
          {$metatag.redirectUrl}
        {/if}
        {else}&nbsp;{/if}
        </dd>
     </dl>
    <h4>{gt text="Social media"}</h4>
     <dl>
        <dt>{gt text='Facebook title'}</dt>
        <dd>{$metatag.facebookTitle}</dd>
        <dt>{gt text='Facebook description'}</dt>
        <dd>{$metatag.facebookDescription}</dd>
        <dt>{gt text='Facebook image'}</dt>
        <dd>{if $metatag.facebookImage ne ''}
          <a href="{$metatag.facebookImageFullPathURL}" title="{$metatag->getTitleFromDisplayPattern()|replace:"\"":""}"{if $metatag.facebookImageMeta.isImage} rel="imageviewer[metatag]"{/if}>
          {if $metatag.facebookImageMeta.isImage}
              {thumb image=$metatag.facebookImageFullPath objectid="metatag-`$metatag.id`" preset=$metatagThumbPresetFacebookImage tag=true img_alt=$metatag->getTitleFromDisplayPattern()}
          {else}
              {gt text='Download'} ({$metatag.facebookImageMeta.size|museoGetFileSize:$metatag.facebookImageFullPath:false:false})
          {/if}
          </a>
        {else}&nbsp;{/if}
        </dd>
        <dt>{gt text='Twitter title'}</dt>
        <dd>{$metatag.twitterTitle}</dd>
        <dt>{gt text='Twitter description'}</dt>
        <dd>{$metatag.twitterDescription}</dd>
        <dt>{gt text='Twitter image'}</dt>
        <dd>{if $metatag.twitterImage ne ''}
          <a href="{$metatag.twitterImageFullPathURL}" title="{$metatag->getTitleFromDisplayPattern()|replace:"\"":""}"{if $metatag.twitterImageMeta.isImage} rel="imageviewer[metatag]"{/if}>
          {if $metatag.twitterImageMeta.isImage}
              {thumb image=$metatag.twitterImageFullPath objectid="metatag-`$metatag.id`" preset=$metatagThumbPresetTwitterImage tag=true img_alt=$metatag->getTitleFromDisplayPattern()}
          {else}
              {gt text='Download'} ({$metatag.twitterImageMeta.size|museoGetFileSize:$metatag.twitterImageFullPath:false:false})
          {/if}
          </a>
        {else}&nbsp;{/if}
        </dd>
        <dt>{gt text='Google plus title'}</dt>
        <dd>{$metatag.googlePlusTitle}</dd>
        <dt>{gt text='Google plus description'}</dt>
        <dd>{$metatag.googlePlusDescription}</dd>
        <dt>{gt text='Google plus image'}</dt>
        <dd>{if $metatag.googlePlusImage ne ''}
          <a href="{$metatag.googlePlusImageFullPathURL}" title="{$metatag->getTitleFromDisplayPattern()|replace:"\"":""}"{if $metatag.googlePlusImageMeta.isImage} rel="imageviewer[metatag]"{/if}>
          {if $metatag.googlePlusImageMeta.isImage}
              {thumb image=$metatag.googlePlusImageFullPath objectid="metatag-`$metatag.id`" preset=$metatagThumbPresetGooglePlusImage tag=true img_alt=$metatag->getTitleFromDisplayPattern()}
          {else}
              {gt text='Download'} ({$metatag.googlePlusImageMeta.size|museoGetFileSize:$metatag.googlePlusImageFullPath:false:false})
          {/if}
          </a>
        {else}&nbsp;{/if}
        </dd>
        <dt>{gt text='Whats app title'}</dt>
        <dd>{$metatag.whatsAppTitle}</dd>
        <dt>{gt text='Page analysis score'}</dt>
        <dd>{$metatag.pageAnalysisScore}</dd>
     </dl>
    <h4>{gt text="Integration"}</h4>
     <dl>
        <dt>{gt text='The module'}</dt>
        <dd>{$metatag.theModule}</dd>
        <dt>{gt text='Function of module'}</dt>
        <dd>{$metatag.functionOfModule}</dd>
        <dt>{gt text='Object of module'}</dt>
        <dd>{$metatag.objectOfModule}</dd>
        <dt>{gt text='Name of identifier'}</dt>
        <dd>{$metatag.nameOfIdentifier}</dd>
        <dt>{gt text='Id of object'}</dt>
        <dd>{$metatag.idOfObject}</dd>
        <dt>{gt text='String of object'}</dt>
        <dd>{$metatag.stringOfObject}</dd>
        <dt>{gt text='Extra infos'}</dt>
        <dd>{$metatag.extraInfos}</dd>
        
    </dl>
    {include file='helper/include_standardfields_display.tpl' obj=$metatag}

    {if !isset($smarty.get.theme) || $smarty.get.theme ne 'Printer'}
        {* include display hooks *}
        {notifydisplayhooks eventname='museo.ui_hooks.metatags.display_view' id=$metatag.id urlobject=$currentUrlObject assign='hooks'}
        {foreach name='hookLoop' key='providerArea' item='hook' from=$hooks}
            {if $providerArea ne 'provider.scribite.ui_hooks.editor'}{* fix for #664 *}
                {$hook}
            {/if}
        {/foreach}
        {if count($metatag._actions) gt 0}
            <p id="itemActions{$metatag.id}">
                {foreach item='option' from=$metatag._actions}
                    <a href="{$option.url.type|museoActionUrl:$option.url.func:$option.url.arguments}" title="{$option.linkTitle|safetext}" class="z-icon-es-{$option.icon}">{$option.linkText|safetext}</a>
                {/foreach}
            </p>
            <script type="text/javascript">
            /* <![CDATA[ */
                document.observe('dom:loaded', function() {
                    mUMUSeoInitItemActions('metatag', 'display', 'itemActions{{$metatag.id}}');
                });
            /* ]]> */
            </script>
        {/if}
    {/if}
</div>
{include file="`$lct`/footer.tpl"}
