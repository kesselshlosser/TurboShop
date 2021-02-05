{$subject="`$btr->email_request_from` `$feedback->name|escape`" scope=global}
<h1 style='font-weight:normal;font-family:arial;'>{$btr->email_request_from|escape} {$feedback->name|escape}</h1>
<table cellpadding=6 cellspacing=0 style='border-collapse: collapse;'>
	<tr>
		<td style='padding:6px; width:170; background-color:#f0f0f0; border:1px solid #e0e0e0;font-family:arial;'>
			{$btr->index_name|escape}
		</td>
		<td style='padding:6px; width:330; background-color:#ffffff; border:1px solid #e0e0e0;font-family:arial;'>
			{$feedback->name|escape}
		</td>
	</tr>
	<tr>
		<td style='padding:6px; width:170; background-color:#f0f0f0; border:1px solid #e0e0e0;font-family:arial;'>
			{$btr->email_order_email|escape}
		</td>
		<td style='padding:6px; width:330; background-color:#ffffff; border:1px solid #e0e0e0;font-family:arial;'>
			<a href='mailto:{$feedback->email|escape}?subject={$settings->site_name}'>{$feedback->email|escape}</a>
		</td>
	</tr>
	<tr>
		<td style='padding:6px; background-color:#f0f0f0; border:1px solid #e0e0e0;font-family:arial;'>
			IP
		</td>
		<td style='padding:6px; width:170; background-color:#ffffff; border:1px solid #e0e0e0;font-family:arial;'>
			{$feedback->ip|escape} (<a href='http://www.ip-adress.com/ip_tracer/{$feedback->ip}/'>{$btr->email_where|escape}</a>)
		</td>
	</tr>
	<tr>
		<td style='padding:6px; width:170; background-color:#f0f0f0; border:1px solid #e0e0e0;font-family:arial;'>
			{$btr->email_message|escape}:
		</td>
		<td style='padding:6px; width:330; background-color:#ffffff; border:1px solid #e0e0e0;font-family:arial;'>
			{$feedback->message|escape|nl2br}
		</td>
	</tr>
</table>
<br><br>
{$btr->email_wish|escape} <a href='https://turbo-cms.com'>Turbo CMS</a>!