{if $comment->approved}
	{$subject="`$btr->email_comment_new` `$comment->name|escape`" scope=global}
{else}
	{$subject="`$btr->email_comment_from` `$comment->name|escape` {$btr->email_comments_unapproved|escape}" scope=global}
{/if}
{if $comment->approved}
<h1 style="font-weight:normal;font-family:arial;"><a href="{$config->root_url}/turbo/index.php?module=CommentsAdmin">{$btr->email_comment_new|escape}</a> {$comment->name|escape}</h1>
{else}
<h1 style="font-weight:normal;font-family:arial;"><a href="{$config->root_url}/turbo/index.php?module=CommentsAdmin">{$btr->email_comment_from|escape}</a> {$comment->name|escape} {$btr->email_comments_unapproved|escape}</h1>
{/if}

<table cellpadding="6" cellspacing="0" style="border-collapse: collapse;">
	<tr>
		<td style="padding:6px; width:170; background-color:#f0f0f0; border:1px solid #e0e0e0;font-family:arial;">
			{$btr->index_name|escape}
		</td>
		<td style="padding:6px; width:330; background-color:#ffffff; border:1px solid #e0e0e0;font-family:arial;">
			{$comment->name|escape}
		</td>
	</tr>
	<tr>
		<td style="padding:6px; background-color:#f0f0f0; border:1px solid #e0e0e0;font-family:arial;">
			{$btr->general_comment|escape}
		</td>
		<td style="padding:6px; background-color:#ffffff; border:1px solid #e0e0e0;font-family:arial;">
			{$comment->text|escape|nl2br}
		</td>
	</tr>
	<tr>
		<td style="padding:6px; background-color:#f0f0f0; border:1px solid #e0e0e0;font-family:arial;">
			{$btr->email_time|escape} 
		</td>
		<td style="padding:6px; width:170; background-color:#ffffff; border:1px solid #e0e0e0;font-family:arial;">
			{$comment->date|date} {$comment->date|time}
		</td>
	</tr>
	<tr>
		<td style="padding:6px; width:170; background-color:#f0f0f0; border:1px solid #e0e0e0;font-family:arial;">
			{$btr->email_status|escape}  
		</td>
		<td style="padding:6px; width:330; background-color:#ffffff; border:1px solid #e0e0e0;font-family:arial;">
			{if $comment->approved}
				{$btr->email_comments_approved|escape}   
			{else}
				{$btr->email_comments_unapproved|escape}
			{/if}
		</td>
	</tr>
	<tr>
		<td style='padding:6px; background-color:#f0f0f0; border:1px solid #e0e0e0;font-family:arial;'>
			IP
		</td>
		<td style='padding:6px; width:170; background-color:#ffffff; border:1px solid #e0e0e0;font-family:arial;'>
			{$comment->ip|escape} (<a href='http://www.ip-adress.com/ip_tracer/{$comment->ip}/'>{$btr->email_where|escape}</a>)
		</td>
	</tr>
	<tr>
		<td style="padding:6px; width:170; background-color:#f0f0f0; border:1px solid #e0e0e0;font-family:arial;">
			{if $comment->type == 'product'}{$btr->email_to_product|escape}{/if}
			{if $comment->type == 'blog'}{$btr->email_to_news|escape}{/if}
			{if $comment->type == 'article'}{$btr->email_to_article|escape}{/if}
		</td>
		<td style="padding:6px; width:330; background-color:#ffffff; border:1px solid #e0e0e0;font-family:arial;">
			{if $comment->type == 'product'}<a target="_blank" href="{$config->root_url}/products/{$comment->product->url}#comment_{$comment->id}">{$comment->product->name}</a>{/if}
			{if $comment->type == 'blog'}<a target="_blank" href="{$config->root_url}/blog/{$comment->post->url}#comment_{$comment->id}">{$comment->post->name}</a>{/if}
			{if $comment->type == 'article'}<a target="_blank" href="{$config->root_url}/article/{$comment->post->url}#comment_{$comment->id}">{$comment->post->name}</a>{/if}
		</td>
	</tr>
</table>
<br><br>
{$btr->email_wish|escape} <a href='https://turbo-cms.com'>Turbo CMS</a>!  