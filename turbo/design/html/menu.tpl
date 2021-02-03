{$meta_title = $btr->menus_menu scope=global}

<div class="row">
    <div class="col-lg-7 col-md-7">
        <div class="wrap_heading">
            <div class="box_heading heading_page">
                {$btr->menus_menu|escape}
			</div>
            <div class="box_btn_heading">
                <a id="add_currency" class="btn btn_small btn-info" href="#">
                    {include file='svg_icon.tpl' svgId='plus'}
                    <span>{$btr->menus_add|escape}</span>
				</a>
			</div>
		</div>
	</div>
</div>

{if $message_error}
<div class="row">
    <div class="col-lg-12 col-md-12 col-sm-12">
        <div class="boxed boxed_warning">
            <div class="heading_box">
				{$message_error|escape}
			</div>
		</div>
	</div>
</div>
{/if}

<div class="boxed fn_toggle_wrap">
    <div class="row">
        <div class="col-lg-12 col-md-12 col-sm-12">
            <form method=post class="fn_form_list">
                <input type="hidden" name="session_id" value="{$smarty.session.id}">
                <div class="turbo_list">
                    <div class="currencies_wrap clearfix">
                        <div class="turbo_list_head">
                            <div class="turbo_list_heading turbo_list_drag"></div>
                            <div class="turbo_list_heading turbo_list_currency_num">ID</div>
                            <div class="turbo_list_heading turbo_list_menus_name">{$btr->menus_name|escape}</div>
                            <div class="turbo_list_heading turbo_list_close"></div>
						</div>
                        <div id="currencies_block" class="turbo_list_body sortable">
                            {foreach $menus as $m}
                            <div class="turbo_list_body_item">
                                <div class="turbo_list_row">
                                    <div class="turbo_list_boding turbo_list_drag move_zone">
                                        {include file='svg_icon.tpl' svgId='drag_vertical'}
									</div>
                                    <div class="turbo_list_boding turbo_list_currency_num">
                                        <span>{$m->id}</span>
									</div>
                                    <div class="turbo_list_boding turbo_list_menus_name">
                                        <input name="menu[id][{$m->id}]" type="hidden" value="{$m->id|escape}" />
                                        <input name="menu[name][{$m->id}]" class="form-control" type="text" value="{$m->name|escape}"/>
									</div>
                                    <div class="turbo_list_boding turbo_list_close turbo_list_menus_close">
                                        {*delete*}
                                        <button data-hint="{$btr->general_delete|escape}" type="button" class=" btn_close fn_remove_currency hint-bottom-right-t-info-s-small-mobile  hint-anim" data-id="{$m->id}">
                                            {include file='svg_icon.tpl' svgId='delete'}
										</button>
									</div>
								</div>
							</div>
                            {/foreach}
                            <div id="new_currency" class="turbo_list_body sortable" style="display: none">
                                <div class="turbo_list_body_item">
                                    <div class="turbo_list_row">
                                        <div class="turbo_list_boding turbo_list_drag move_zone">
                                            {include file='svg_icon.tpl' svgId='drag_vertical'}
										</div>
                                        <div class="turbo_list_boding turbo_list_currency_num"></div>
                                        <div class="turbo_list_boding turbo_list_menus_name">
                                            <input name="menu[id][]" type="hidden" value=""/>
                                            <input name="menu[name][]" class="form-control" type="text" value=""/>
										</div>
                                        <div class="turbo_list_boding turbo_list_close turbo_list_menus_close"></div>
									</div>
								</div>
							</div>
						</div>
                        <div id="action" class="turbo_list_footer">
                            <div class="turbo_list_foot_left"></div>
                            <input type="hidden" name="recalculate" value="0">
                            <input type="hidden" name="action" value="">
                            <input type="hidden" name="action_id" value="">
                            <button id="apply_action" type="submit" class="btn btn_small btn_green">
                                {include file='svg_icon.tpl' svgId='checked'}
                                <span>{$btr->general_apply|escape}</span>
							</button>
						</div>
					</div>
				</div>
			</form>
		</div>
	</div>
</div>
<script>
    var general_confirm_delete = 'Подтвердите удаление';
</script>
{* On document load *}
{literal}
<script>
    $(function() {
        // Add menu
        var curr = $('#new_currency').clone(true);
        $('#new_currency').remove().removeAttr('id');
        $('a#add_currency').click(function() {
            $(curr).clone(true).appendTo('#currencies_block').fadeIn('slow').find("input[name*=currency][name*=name]").focus();
            return false;
		});
        $(document).on("click", ".fn_remove_currency ", function () {
            $('input[type="hidden"][name="action"]').val('delete');
            $('input[type="hidden"][name="action_id"]').val($(this).data("id"));
            $(".fn_form_list").submit();
		});
        $(".fn_form_list").submit(function() {
            if($('input[type="hidden"][name="action"]').val()=='delete' && !confirm(general_confirm_delete)) {
                return false;
			}
		});
	});
</script>
{/literal}