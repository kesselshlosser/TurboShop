{$subject="`$btr->email_callback_request` `$callback->name|escape`" scope=global}

<h1 style="font-weight:normal;font-family:arial;">{$btr->email_callback_request|escape} {$callback->name|escape}</h1>

<table cellpadding="6" cellspacing="0" style="border-collapse: collapse;">
	<tr>
		<td style="padding:6px; width:170; background-color:#f0f0f0; border:1px solid #e0e0e0;font-family:arial;">
			{$btr->index_name|escape}
		</td>
		<td style="padding:6px; width:330; background-color:#ffffff; border:1px solid #e0e0e0;font-family:arial;">
			{$callback->name|escape}
		</td>
	</tr>
	<tr>
		<td style="padding:6px; width:170; background-color:#f0f0f0; border:1px solid #e0e0e0;font-family:arial;">
			{$btr->general_phone|escape}
		</td>
		<td style="padding:6px; width:330; background-color:#ffffff; border:1px solid #e0e0e0;font-family:arial;">
			{$callback->phone|escape}
		</td>
	</tr>
	{if $callback->message}
	<tr>
		<td style="padding:6px; width:170; background-color:#f0f0f0; border:1px solid #e0e0e0;font-family:arial;">
			{$btr->general_message|escape}
		</td>
		<td style="padding:6px; width:330; background-color:#ffffff; border:1px solid #e0e0e0;font-family:arial;">
			{$callback->message|escape|nl2br}
		</td>
	</tr>
	{/if}
</table>
<br><br>
{$btr->email_wish|escape} <a href='https://turbo-cms.com'>Turbo CMS</a>!