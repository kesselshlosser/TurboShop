{* Title *}
{$meta_title=$btr->order_settings_labels scope=global}

<div class="row">
    <div class="col-lg-7 col-md-12">
        <div class="wrap_heading">
            <div class="box_heading heading_page">
                {$btr->order_settings_labels|escape}
            </div>
            <div class="box_btn_heading">
                <a class="btn btn_small btn-info" href="{url module=OrdersLabelAdmin}">
                    {include file='svg_icon.tpl' svgId='plus'}
                    <span>{$btr->order_settings_add_label|escape}</span>
                </a>
            </div>
           
        </div>
    </div>
</div>

<div class="boxed fn_toggle_wrap">
	{if $labels}
    <div class="toggle_body_wrap on fn_card">
		<form class="fn_form_list" method="post">
            <input type="hidden" value="labels" name="labels">
            <input type="hidden" name="session_id" value="{$smarty.session.id}">
            <div class="turbo_list">
                <div class="turbo_list_head">
                    <div class="turbo_list_heading turbo_list_check">
                        <input class="hidden_check fn_check_all" type="checkbox" id="check_all_1" name="" value=""/>
                        <label class="turbo_ckeckbox" for="check_all_1"></label>
                    </div>
                    <div class="turbo_list_heading turbo_list_order_stg_lbl_name">{$btr->general_name|escape}</div>
                    <div class="turbo_list_heading turbo_list_order_stg_sts_label">{$btr->general_color|escape}</div>
                    <div class="turbo_list_heading turbo_list_close"></div>
                </div>
                <div class="fn_labels_list turbo_list_body sortable fn_sort_list">
                    {foreach $labels as $label}
                    <div class="fn_row turbo_list_body_item body_narrow">
                        <div class="turbo_list_row fn_sort_item narrow">
                            <input type="hidden" name="positions[{$label->id}]" value="{$label->position}">
                            <input type="hidden" name="id[]" value="{$label->id}">
                            <div class="cturbo_list_boding turbo_list_check">
                                <input class="hidden_check" type="checkbox" id="id_{$label->id}" name="check[]" value="{$label->id}"/>
                                <label class="turbo_ckeckbox" for="id_{$label->id}"></label>
                            </div>
                            <div class="turbo_list_boding turbo_list_order_stg_lbl_name">
                                <a href="{url module=OrdersLabelAdmin id=$label->id return=$smarty.server.REQUEST_URI}">{$label->name|escape}</a>
                            </div>
                            <div class="turbo_list_boding turbo_list_order_stg_sts_label">
                                <a href="{url module=OrdersLabelAdmin id=$label->id return=$smarty.server.REQUEST_URI}" data-hint="#{$label->color}" class="label_color_item hint-bottom-middle-t-info-s-small-mobile  hint-anim" style="background-color:#{$label->color};"></a>
                            </div>
                            <div class="turbo_list_boding turbo_list_close">
                                {*delete*}
                                <button data-hint="{$btr->general_delete|escape}" type="button" class="btn_close fn_remove hint-bottom-right-t-info-s-small-mobile  hint-anim" data-toggle="modal" data-target="#fn_action_modal" onclick="success_action($(this));">
                                    {include file='svg_icon.tpl' svgId='delete'}
                                </button>
                            </div>
                        </div>
                    </div>
                    {/foreach}
                </div>
                <div class="turbo_list_footer ">
                    <div class="turbo_list_foot_left">
                        <div class="turbo_list_heading turbo_list_check">
                            <input class="hidden_check fn_check_all" type="checkbox" id="check_all_2" name="" value=""/>
                            <label class="turbo_ckeckbox" for="check_all_2"></label>
                        </div>
                        <div class="turbo_list_option">
                            <select name="action" class="selectpicker">
                                <option value="delete">{$btr->general_delete|escape}</option>
                            </select>
                        </div>
                    </div>
                    <button type="submit" value="labels" class="btn btn_small btn_green">
                        {include file='svg_icon.tpl' svgId='checked'}
                        <span>{$btr->general_apply|escape}</span>
                    </button>
                </div>
            </div>
        </form>
    </div>
	{else}
	 <div class="heading_box mt-1">
        <div class="text_grey">{$btr->no_labels|escape}</div>
    </div>
	{/if}
</div>
{* On document load *}
{literal}
<link rel="stylesheet" media="screen" type="text/css" href="design/js/colorpicker/css/colorpicker.css" />
<script type="text/javascript" src="design/js/colorpicker/js/colorpicker.js"></script>
<script>
    $(function() {
        var new_label = $(".fn_new_label").clone(true);
        $(".fn_new_label").remove();
        $(document).on("click", ".fn_add_Label", function () {
            clone_label = new_label.clone(true);
            $(".fn_labels_list").append(clone_label);
        });
    });
</script>
{/literal}