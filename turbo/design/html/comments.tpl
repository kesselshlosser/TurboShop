{* Title *}
{$meta_title=$btr->general_comments scope=global}

<div class="row">
    <div class="col-lg-7 col-md-7">
        <div class="wrap_heading">
            <div class="box_heading heading_page">
				{if !$type}
                    {$btr->general_comments} - {$comments_count}
                {elseif $type=='product'}
                    {$btr->general_comments} {$btr->comments_to_products|escape} - {$comments_count}
                {elseif $type=='blog'}
                    {$btr->general_comments} {$btr->comments_to_articles|escape} - {$comments_count}
				{elseif $type=='article'}
                   {$btr->general_comments} {$btr->comments_to_articles|escape} - {$comments_count} 
                {/if}
            </div>
        </div>
    </div>
	 <div class="col-md-12 col-lg-5 col-xs-12 float-xs-right">
        <div class="boxed_search">
            <form class="search" method="get">
                <input type="hidden" name="module" value="CommentsAdmin">
                <div class="input-group">
                    <input name="keyword" class="form-control" placeholder="{$btr->comments_search|escape}" type="text" value="{$keyword|escape}" >
                    <span class="input-group-btn">
                        <button type="submit" class="btn btn_green"><i class="fa fa-search"></i> <span class="hidden-md-down"></span></button>
                    </span>
                </div>
            </form>
        </div>
    </div>
</div>

<div class="boxed fn_toggle_wrap">
    <div class="row">
        <div class="col-lg-12 col-md-12">
            <div class="boxed_sorting">
                <div class="row">
                    <div class="col-lg-3 col-md-3 col-sm-12">
                        <select class="selectpicker form-control" onchange="location = this.value;">
                            <option value="{url type=null}" {if !$type}selected{/if}>{$btr->comments_all|escape}</option>
                            <option value="{url keyword=null type=product}" {if $type == 'product'}selected{/if}>{$btr->comments_to_products|escape}</option>
                            <option value="{url keyword=null type=blog}" {if $type == 'blog'}selected{/if}>{$btr->comments_to_news|escape}</option>
							<option value="{url keyword=null type=article}" {if $type == 'article'}selected{/if}>{$btr->comments_to_articles|escape}</option>
                        </select>
                    </div>
                </div>
            </div>
        </div>
    </div>
    {if $comments}
    <div class="row">
        {* Основная форма *}
        <div class="col-lg-12 col-md-12 col-sm-12">
            <form class="fn_form_list" method="post">
                <input type="hidden" name="session_id" value="{$smarty.session.id}">
                <div class="post_wrap turbo_list">
                    <div class="turbo_list_head">
                        <div class="turbo_list_heading turbo_list_check">
                            <input class="hidden_check fn_check_all" type="checkbox" id="check_all_1" name="" value=""/>
                            <label class="turbo_ckeckbox" for="check_all_1"></label>
                        </div>
                        <div class="turbo_list_heading turbo_list_comments_name">{$btr->general_comments|escape}</div>
                        <div class="turbo_list_heading turbo_list_comments_btn"></div>
                        <div class="turbo_list_heading turbo_list_close"></div>
                    </div>
                    <div class="turbo_list_body">
                        {function name=comments_tree level=0}
                        {foreach $comments as $comment}
                        <div class="fn_row turbo_list_body_item {if !$comment->approved}unapproved{/if} {if $level > 0}admin_note2{/if}">
                            <div class="turbo_list_row">
                                
                                <div class="turbo_list_boding turbo_list_check">
                                    <input class="hidden_check" type="checkbox" id="id_{$comment->id}" name="check[]" value="{$comment->id}"/>
                                    <label class="turbo_ckeckbox" for="id_{$comment->id}"></label>
                                </div>
                                
                                <div class="turbo_list_boding turbo_list_comments_name {if $level > 0}admin_note{/if}">
                                    <div class="turbo_list_text_inline mb-q mr-1">
                                        <span class="text_dark text_bold">{$btr->general_name|escape}: </span> {$comment->name|escape}
                                    </div>
                                    {if $comment->email}
                                    <div class="turbo_list_text_inline mb-q">
                                        <span class="text_dark text_bold">Email: </span>  {$comment->email|escape}
                                    </div>
                                    {/if}
                                    <div class="mb-q">
                                        <span class="text_dark text_bold">{$btr->general_message|escape}:</span>
                                        {$comment->text|escape|nl2br}
                                    </div>
                                    <div class="">
                                        {$btr->comments_left|escape} <span class="tag tag-default">{$comment->date|date} | {$comment->date|time}</span>
                                        {$btr->comments_to_the|escape}
										{if $comment->type == 'product'}
                                        {$btr->comments_product|escape} <a target="_blank" href="{$config->root_url}/products/{$comment->product->url}#comment_{$comment->id}">{$comment->product->name}</a>
                                        {elseif $comment->type == "blog"}
                                        {$btr->comments_blog|escape} <a href="{$config->root_url}/blog/{$comment->post->url|escape}#comment_{$comment->id}" target="_blank">{$comment->post->name|escape}</a>
										{elseif $comment->type == 'article'}
                                        {$btr->comments_article|escape} <a target="_blank" href="{$config->root_url}/article/{$comment->article->url}#comment_{$comment->id}">{$comment->article->name}</a>
                                        {/if}
                                    </div>
                                    <div class="hidden-md-up mt-q">
                                        {if !$comment->approved}
                                        <button type="button" class="btn btn_small btn-outline-warning fn_ajax_action {if $comment->approved}fn_active_class{/if}" data-module="comment" data-action="approved" data-id="{$comment->id}" onclick="$(this).hide();">
                                            {$btr->general_process|escape}
                                        </button>
                                        {/if}
                                    </div>
                                </div>
                                
                                <div class="turbo_list_boding turbo_list_comments_btn">
                                    {if !$comment->approved}
                                    <button type="button" class="btn btn_small btn-outline-warning fn_ajax_action {if $comment->approved}fn_active_class{/if}" data-module="comment" data-action="approved" data-id="{$comment->id}" onclick="$(this).hide();">
                                        {$btr->general_process|escape}
                                    </button>
                                    {/if}
                                </div>
                                
                                <div class="turbo_list_boding turbo_list_close">
                                    {*delete*}
                                    <button data-hint="{$btr->comments_delete|escape}" type="button" class="btn_close fn_remove hint-bottom-right-t-info-s-small-mobile  hint-anim" data-toggle="modal" data-target="#fn_action_modal" onclick="success_action($(this));">
                                        {include file='svg_icon.tpl' svgId='delete'}
                                    </button>
                                </div>
                                
                            </div>
                            {if isset($children[$comment->id])}
								{comments_tree comments=$children[$comment->id] level=$level+1}
                            {/if}
                        </div>
                        
                        {/foreach}
                        {/function}
                        {comments_tree comments=$comments}
                    </div>
                    
                    <div class="turbo_list_footer fn_action_block">
                        <div class="turbo_list_foot_left">
                            <div class="turbo_list_heading turbo_list_check">
                                <input class="hidden_check fn_check_all" type="checkbox" id="check_all_2" name="" value=""/>
                                <label class="turbo_ckeckbox" for="check_all_2"></label>
                            </div>
                            <div class="turbo_list_option">
                                <select name="action" class="selectpicker">
                                    <option value="approve">{$btr->general_process|escape}</option>
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
        <div class="text_grey">{$btr->comments_no|escape}</div>
    </div>
    {/if}
</div>