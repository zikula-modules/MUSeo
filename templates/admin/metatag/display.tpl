{* purpose of this template: metatags display view in admin area *}
{include file='admin/header.tpl'}
<div class="museo-metatag museo-display">
{gt text='Metatag' assign='templateTitle'}
{assign var='templateTitle' value=$metatag.titleOfEntity|default:$templateTitle}
{pagesetvar name='title' value=$templateTitle|@html_entity_decode}
<div class="z-admin-content-pagetitle">
    {icon type='display' size='small' __alt='Details'}
    <h3>{$templateTitle|notifyfilters:'museo.filter_hooks.metatags.filter'}</h3>
</div>


<dl id="MUSeo_body">
    <dt>{gt text='Title'}</dt>
    <dd>{$metatag.title}</dd>
    <dt>{gt text='Description'}</dt>
    <dd>{$metatag.description}</dd>
    <dt>{gt text='Keywords'}</dt>
    <dd>{$metatag.keywords}</dd>
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
    {include file='admin/include_standardfields_display.tpl' obj=$metatag}

{if !isset($smarty.get.theme) || $smarty.get.theme ne 'Printer'}
{if count($metatag._actions) gt 0}
    <p>{strip}
    {foreach item='option' from=$metatag._actions}
        <a href="{$option.url.type|museoActionUrl:$option.url.func:$option.url.arguments}" title="{$option.linkTitle|safetext}" class="z-icon-es-{$option.icon}">
            {$option.linkText|safetext}
        </a>
    {/foreach}
    {/strip}</p>
{/if}

{* include display hooks *}
{notifydisplayhooks eventname='museo.ui_hooks.metatags.display_view' id=$metatag.id urlobject=$currentUrlObject assign='hooks'}
{foreach key='hookname' item='hook' from=$hooks}
    {$hook}
{/foreach}

{/if}

</div>
{include file='admin/footer.tpl'}

