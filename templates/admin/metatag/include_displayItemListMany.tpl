{* purpose of this template: inclusion template for display of related Metatags in admin area *}

{if isset($items) && $items ne null}
<ul class="relatedItemList Metatag">
{foreach name='relLoop' item='item' from=$items}
    <li>
    <a href="{modurl modname='MUSeo' type='admin' func='display' ot='metatag' id=$item.id}">
        {$item.titleOfEntity}
    </a>
    <a id="metatagItem{$item.id}Display" href="{modurl modname='MUSeo' type='admin' func='display' ot='metatag' id=$item.id theme='Printer'}" title="{gt text='Open quick view window'}" style="display: none">
        {icon type='view' size='extrasmall' __alt='Quick view'}
    </a>
    <script type="text/javascript" charset="utf-8">
    /* <![CDATA[ */
        document.observe('dom:loaded', function() {
            museoInitInlineWindow($('metatagItem{{$item.id}}Display'), '{{$item.titleOfEntity|replace:"'":""}}');
        });
    /* ]]> */
    </script>

    </li>
{/foreach}
</ul>
{/if}

