{* Title *}
{$meta_title=$btr->subscribe_mailing_subscribes scope=global}

{if $subscribes_count>0}
    <div class="row">
        <progress id="progressbar" class="progress progress-xs progress-info mt-0" style="display: none" value="0" max="100"></progress>
    </div>
{/if}

<div class="row">
    <div class="col-lg-12 col-md-12">
        <div class="heading_page">
            {if $keyword && $subscribes_count>0}
                {$btr->subscribe_mailing_subscribes|escape} - {$subscribes_count}
            {elseif $subscribes_count>0}
                {$btr->subscribe_mailing_subscribes|escape} - {$subscribes_count}
            {/if}
            
            {if $subscribes_count>0}
                <div class="export_block export_subscribes hint-bottom-middle-t-info-s-small-mobile  hint-anim" data-hint="{$btr->subscribe_mailing_export|escape}">
                    <span class="fn_start_export fa fa-file-excel-o"></span>
                </div>
            {/if}
        </div>
    </div>
</div>

<div class="boxed fn_toggle_wrap">
    {if $subscribes}
    <div class="row">
        <div class="col-lg-12 col-md-12 col-sm-12">
            <form class="fn_form_list" method="post">
                <input type="hidden" name="session_id" value="{$smarty.session.id}"/>
                <div class="users_wrap turbo_list">
                    <div class="turbo_list_head">
                        <div class="turbo_list_heading turbo_list_check">
                            <input class="hidden_check fn_check_all" type="checkbox" id="check_all_1" name="" value=""/>
                            <label class="turbo_ckeckbox" for="check_all_1"></label>
                        </div>
                        <div class="turbo_list_heading turbo_list_subscribe_name">Email</div>
                        <div class="turbo_list_heading turbo_list_close"></div>
                    </div>
                    <div class="turbo_list_body sortable">
                        {foreach $subscribes as $subscribe}
                        <div class="fn_row turbo_list_body_item {if !$subscribe->processed}unapproved{/if} body_narrow">
                            <div class="turbo_list_row narrow">
                                <div class="turbo_list_boding turbo_list_check">
                                    <input class="hidden_check" type="checkbox" id="id_{$subscribe->id}" name="check[]" value="{$subscribe->id}"/>
                                    <label class="turbo_ckeckbox" for="id_{$subscribe->id}"></label>
                                </div>
                                
                                <div class="turbo_list_boding turbo_list_subscribe_name">
                                    <a class="link" href="mailto:{$subscribe->email|escape}">
                                        {$subscribe->email|escape}
                                    </a>
                                    <div>
                                        {$btr->general_request_sent|escape}: <span class="tag tag-default">{$subscribe->date|date} | {$subscribe->date|time}</span>
                                    </div>
                                    {if !$subscribe->processed}
                                    <div class="hidden-md-up mt-q">
                                        <button type="button" class="btn btn_small btn-outline-warning fn_ajax_action {if $subscribe->processed}fn_active_class{/if}" data-module="subscribe" data-action="processed" data-id="{$subscribe->id}" onclick="$(this).hide();">
                                            {$btr->general_process|escape}
                                        </button>
                                    </div>
                                    {/if}
                                </div>
                                <div class="turbo_list_boding turbo_list_comments_btn">
                                    {if !$subscribe->processed}
                                    <button type="button" class="btn btn_small unapproved btn-outline-warning fn_ajax_action {if $subscribe->processed}fn_active_class{/if}" data-module="subscribe" data-action="processed" data-id="{$subscribe->id}" onclick="$(this).hide();">
										{$btr->general_process|escape}
                                    </button>
                                    {/if}
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
                    <div class="turbo_list_footer fn_action_block">
                        <div class="turbo_list_foot_left">
                            <div class="turbo_list_heading turbo_list_check">
                                <input class="hidden_check fn_check_all" type="checkbox" id="check_all_2" name="" value=""/>
                                <label class="turbo_ckeckbox" for="check_all_2"></label>
                            </div>
                            <div class="turbo_list_option">
                                <select name="action" class="selectpicker">
                                    <option value="processed">{$btr->general_process|escape}</option>
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
        </div>
    </div>
	<div class="row">
		<div class="col-lg-12 col-md-12 col-sm 12 txt_center">
			{include file='pagination.tpl'}
		</div>
		</div>
    {else}
    <div class="heading_box mt-1">
        <div class="text_grey">{$btr->subscribe_mailing_mo|escape}</div>
    </div>
    {/if}
</div>
<script src="{$config->root_url}/turbo/design/js/piecon/piecon.js"></script>
<script>
    var in_process=false;
    var keyword='{$keyword|escape}';
    var sort='{$sort|escape}';

    {literal}
    $(function() {

        $(document).on('click','.fn_start_export',function(){
            Piecon.setOptions({fallback: 'force'});
            Piecon.setProgress(0);
            var progress_item = $("#progressbar"); //specify an element selector with animation
            progress_item.show();
            do_export('',progress_item);
        });

        function do_export(page,progress) {
            page = typeof(page) != 'undefined' ? page : 1;
            $.ajax({
                url: "ajax/export_subscribes.php",
                data: {page:page, keyword:keyword, sort:sort},
                dataType: 'json',
                success: function(data){
                    if(data && !data.end)
                    {
                        Piecon.setProgress(Math.round(100*data.page/data.totalpages));
                        progress.attr('value',100*data.page/data.totalpages);
                        do_export(data.page*1+1,progress);
                    }
                    else
                    {
                        Piecon.setProgress(100);
                        progress.attr('value','100');
                        window.location.href = 'files/export_users/subscribes.csv';
                        progress.fadeOut(500);
                    }
                },
                error:function(xhr, status, errorThrown) {
                    alert(errorThrown+'\n'+xhr.responseText);
                }

            });
        }
    });
</script>
{/literal}