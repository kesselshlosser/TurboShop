{* Title *}
{$meta_title=$btr->general_categories scope=global}

<div class="row">
    <div class="col-lg-7 col-md-7">
        <div class="wrap_heading">
            <div class="box_heading heading_page">
                {$btr->general_categories|escape}
            </div>
            <div class="box_btn_heading">
                <a class="btn btn_small btn-info" href="{url module=ArticlesCategoryAdmin return=$smarty.server.REQUEST_URI}">
                    {include file='svg_icon.tpl' svgId='plus'}
                    <span>{$btr->categories_add|escape}</span>
                </a>
            </div>
        </div>
    </div>
</div>

<div class="boxed fn_toggle_wrap">
    {if $articles_categories}
    <form method="post" class="fn_form_list">
        <input type="hidden" name="session_id" value="{$smarty.session.id}" />
        <div class="turbo_list products_list fn_sort_list">
            <div class="turbo_list_head">
                <div class="turbo_list_heading turbo_list_subicon"></div>
                <div class="turbo_list_heading turbo_list_drag"></div>
                <div class="turbo_list_heading turbo_list_check">
                    <input class="hidden_check fn_check_all" type="checkbox" id="check_all_1" name="" value=""/>
                    <label class="turbo_ckeckbox" for="check_all_1"></label>
                </div>
                <div class="turbo_list_heading turbo_list_photo hidden-sm-down">{$btr->general_photo|escape}</div>
                <div class="turbo_list_heading turbo_list_categories_name">{$btr->general_name|escape}</div>
                <div class="turbo_list_heading turbo_list_status">{$btr->general_enable|escape}</div>
                <div class="turbo_list_heading turbo_list_setting">{$btr->general_activities|escape}</div>
                <div class="turbo_list_heading turbo_list_close"></div>
            </div>
            <div class="turbo_list_body categories_wrap sortable">
				{function name=categories_tree level=1}
                {if $articles_categories}
                {foreach $articles_categories as $category}
                {if $level > 1}
                <div class="fn_row row_narrow">
                    {/if}
                    <div class="fn_row {if $level == 1}turbo_list_body_item{/if} fn_sort_item body_narrow row_narrow">
                        <div class="turbo_list_row {if $level > 1}fn_sort_item{/if} narrow">
                            <input type="hidden" name="positions[{$category->id}]" value="{$category->position}" />
                            {if $category->subcategories}
                            <div class="turbo_list_heading turbo_list_subicon">
                                <a href="javascript:;" class="fn_ajax_toggle" data-toggle="0" data-category_id="{$category->id}" >
                                    <i class="fa fa-plus-square"></i>
                                </a>
                            </div>
                            {else}
                            <div class="turbo_list_heading turbo_list_subicon"></div>
                            {/if}
                            <div class="turbo_list_boding turbo_list_drag move_zone">
                                {include file='svg_icon.tpl' svgId='drag_vertical'}
                            </div>
                            <div class="turbo_list_boding turbo_list_check">
                                <input class="hidden_check" type="checkbox" id="id_{$category->id}" name="check[]" value="{$category->id}" />
                                <label class="turbo_ckeckbox" for="id_{$category->id}"></label>
                            </div>
                            <div class="turbo_list_boding turbo_list_photo hidden-sm-down small_photo boding_small">
                                {if $category->image}
                                <a href="{url module=ArticlesCategoryAdmin id=$category->id return=$smarty.server.REQUEST_URI}">
                                    <img src="{$category->image|resize_catalog:35:35}" alt="" />
                                </a>
                                {else}
                                <a href="{url module=ArticlesCategoryAdmin id=$category->id return=$smarty.server.REQUEST_URI}">
                                    <i class="fa fa-picture-o fa-2-2x mt-w" aria-hidden="true"></i>
                                </a>
                                {/if}
                            </div>
                            <div class="turbo_list_boding turbo_list_categories_name">
                                <a class="link" href="{url module=ArticlesCategoryAdmin id=$category->id return=$smarty.server.REQUEST_URI}">
                                    {$category->name|escape}
                                </a>
                            </div>
                            <div class="turbo_list_boding turbo_list_status">
                                {*visible*}
                                <label class="switch switch-default">
                                    <input class="switch-input fn_ajax_action {if $category->visible}fn_active_class{/if}" data-module="articles_category" data-action="visible" data-id="{$category->id}" name="visible" value="1" type="checkbox"  {if $category->visible}checked=""{/if}/>
                                    <span class="switch-label"></span>
                                    <span class="switch-handle"></span>
                                </label>
                            </div>
                            <div class=" turbo_list_setting">
                                {*open*}
                                <a href="../articles/{$category->url}" target="_blank" data-hint="{$btr->general_view|escape}" class="setting_icon setting_icon_open hint-bottom-middle-t-info-s-small-mobile  hint-anim">
                                    {include file='svg_icon.tpl' svgId='icon_desktop'}
                                </a>
                            </div>
                            <div class="turbo_list_boding turbo_list_close">
                                {*delete*}
                                <button data-hint="{$btr->categories_delete|escape}" type="button" class="btn_close fn_remove hint-bottom-right-t-info-s-small-mobile  hint-anim" data-toggle="modal" data-target="#fn_action_modal" onclick="success_action($(this));">
                                    {include file='svg_icon.tpl' svgId='delete'}
                                </button>
                            </div>
                        </div>
                        {if $category->subcategories}
                        <div class="fn_ajax_categories categories_sub_block subcategories_level_{$level} sortable" style="display: none;">
                            {categories_tree articles_categories=$category->subcategories level=$level+1}
                        </div>
                        {/if}
                    </div>
                    {if $level > 1} 
                </div>
                {/if}
                {/foreach}
                {/if}
                {/function}
				{categories_tree articles_categories=$articles_categories}
            </div>
            <div class="turbo_list_footer fn_action_block">
                <div class="turbo_list_foot_left">
                    <div class="turbo_list_heading turbo_list_subicon"></div>
                    <div class="turbo_list_heading turbo_list_drag"></div>
                    <div class="turbo_list_heading turbo_list_check">
                        <input class="hidden_check fn_check_all" type="checkbox" id="check_all_2" name="" value=""/>
                        <label class="turbo_ckeckbox" for="check_all_2"></label>
                    </div>
                    <div class="turbo_list_option">
                        <select name="action" class="selectpicker">
                            <option value="enable">{$btr->general_do_enable|escape}</option>
                            <option value="disable">{$btr->general_do_disable|escape}</option>
                            <option value="delete">{$btr->general_delete|escape}</option>
                        </select>
                    </div>
                </div>
                <button type="submit" class="btn btn_small btn_green">
                    {include file='svg_icon.tpl' svgId='checked'}
                    <span>{$btr->general_apply|escape}</span>
                </button>
            </div>
        </div>
    </form>
    {else}
    <div class="heading_box mt-1">
        <div class="text_grey">{$btr->categories_no|escape}</div>
    </div>
    {/if}
</div>
<script>
    $(document).on("click", ".fn_ajax_toggle", function () {
        elem = $(this);
        var el = document.querySelectorAll("div.sortable , .fn_ajax_categories.sortable");
        for (i = 0; i < el.length; i++) {
            var sortable = Sortable.create(el[i], {
                handle: ".move_zone",  // Drag handle selector within list items
                sort: true,  // sorting inside list
                animation: 150,  // ms, animation speed moving items when sorting, `0` — without animation
                scroll: true, // or HTMLElement
                ghostClass: "sortable-ghost",  // Class name for the drop placeholder
                chosenClass: "sortable-chosen",  // Class name for the chosen item
                dragClass: "sortable-drag",  // Class name for the dragging item
                scrollSensitivity: 30, // px, how near the mouse must be to an edge to start scrolling.
                scrollSpeed: 10, // px
            });
        }
        elem.closest(".fn_row").children(".fn_ajax_categories").slideToggle(500);
        elem.find("i").toggleClass("fa-minus-square");
    });
</script>   