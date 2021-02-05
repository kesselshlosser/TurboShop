{* User order letter template *}

{$subject = "`$lang->email_order_title` `$order->id`" scope=global}
<h1 style="font-weight:normal;font-family:arial;">
	<a href="{$config->root_url}/order/{$order->url}">{$lang->email_order_title} {$order->id}</a>
	{$lang->email_order_on_total} {$order->total_price|convert:$currency->id}&nbsp;{$currency->sign}
	{if $order->paid == 1}{$lang->paid}{else}{$lang->not_paid}{/if},
	{if $order->status == 0}{$lang->waiting_for_processing}{elseif $order->status == 1}{$lang->in_processing}{elseif $order->status == 2}{$lang->completed}{elseif $order->status == 3}{$lang->canceled}{/if}
</h1>
<table cellpadding="6" cellspacing="0" style="border-collapse: collapse;">
	<tr>
		<td style="padding:6px; width:170; background-color:#f0f0f0; border:1px solid #e0e0e0;font-family:arial;">
			{$lang->status}
		</td>
		<td style="padding:6px; width:330; background-color:#ffffff; border:1px solid #e0e0e0;font-family:arial;">
			{if $order->status == 0}
				{$lang->waiting_for_processing}      
			{elseif $order->status == 1}
				{$lang->in_processing}
			{elseif $order->status == 2}
				{$lang->completed}
			{elseif $order->status == 3}
				{$lang->canceled}
			{/if}
		</td>
	</tr>
	<tr>
		<td style="padding:6px; width:170; background-color:#f0f0f0; border:1px solid #e0e0e0;font-family:arial;">
			{$lang->general_payment}
		</td>
		<td style="padding:6px; width:330; background-color:#ffffff; border:1px solid #e0e0e0;font-family:arial;">
			{if $order->paid == 1}
			<font color="green">{$lang->paid}</font>
			{else}
				{$lang->not_paid}
			{/if}
		</td>
	</tr>
	{if $order->name}
	<tr>
		<td style="padding:6px; width:170; background-color:#f0f0f0; border:1px solid #e0e0e0;font-family:arial;">
			{$lang->general_full_name}
		</td>
		<td style="padding:6px; width:330; background-color:#ffffff; border:1px solid #e0e0e0;font-family:arial;">
			{$order->name|escape}
		</td>
	</tr>
	{/if}
	{if $order->email}
	<tr>
		<td style="padding:6px; background-color:#f0f0f0; border:1px solid #e0e0e0;font-family:arial;">
			Email
		</td>
		<td style="padding:6px; background-color:#ffffff; border:1px solid #e0e0e0;font-family:arial;">
			{$order->email|escape}
		</td>
	</tr>
	{/if}
	{if $order->phone}
	<tr>
		<td style="padding:6px; background-color:#f0f0f0; border:1px solid #e0e0e0;font-family:arial;">
			{$lang->phone}
		</td>
		<td style="padding:6px; background-color:#ffffff; border:1px solid #e0e0e0;font-family:arial;">
			{$order->phone|escape}
		</td>
	</tr>
	{/if}
	{if $order->address}
	<tr>
		<td style="padding:6px; background-color:#f0f0f0; border:1px solid #e0e0e0;font-family:arial;">
			{$lang->delivery_address}
		</td>
		<td style="padding:6px; background-color:#ffffff; border:1px solid #e0e0e0;font-family:arial;">
			{$order->address|escape}
		</td>
	</tr>
	{/if}
	{if $order->comment}
	<tr>
		<td style="padding:6px; background-color:#f0f0f0; border:1px solid #e0e0e0;font-family:arial;">
			{$lang->comment}
		</td>
		<td style="padding:6px; background-color:#ffffff; border:1px solid #e0e0e0;font-family:arial;">
			{$order->comment|escape|nl2br}
		</td>
	</tr>
	{/if}
	<tr>
		<td style="padding:6px; background-color:#f0f0f0; border:1px solid #e0e0e0;font-family:arial;">
			{$lang->order_date}
		</td>
		<td style="padding:6px; width:170; background-color:#ffffff; border:1px solid #e0e0e0;font-family:arial;">
			{$order->date|date} {$order->date|time}
		</td>
	</tr>
</table>

<h1 style="font-weight:normal;font-family:arial;">{$lang->you_ordered}:</h1>

<table cellpadding="6" cellspacing="0" style="border-collapse: collapse;">

	{foreach $purchases as $purchase}
	<tr>
		<td align="center" style="padding:6px; width:100; padding:6px; background-color:#ffffff; border:1px solid #e0e0e0;font-family:arial;">
			{$image = $purchase->product->images[0]}
			<a href="{$config->root_url}/products/{$purchase->product->url}"><img border="0" src="{$image->filename|resize:50:50}"></a>
		</td>
		<td style="padding:6px; width:250; padding:6px; background-color:#f0f0f0; border:1px solid #e0e0e0;font-family:arial;">
			<a href="{$config->root_url}/products/{$purchase->product->url}">{$purchase->product_name}</a>
			{$purchase->variant_name}
		</td>
		<td align=right style="padding:6px; text-align:right; width:150; background-color:#ffffff; border:1px solid #e0e0e0;font-family:arial;">
			{$purchase->amount} {$settings->units} &times; {$purchase->price|convert:$currency->id}&nbsp;{$currency->sign}
		</td>
	</tr>
	{/foreach}
	
	{if $order->discount}
	<tr>
		<td style="padding:6px; width:100; padding:6px; background-color:#ffffff; border:1px solid #e0e0e0;font-family:arial;"></td>
		<td style="padding:6px; background-color:#f0f0f0; border:1px solid #e0e0e0;font-family:arial;">
			{$lang->discount}
		</td>
		<td align=right style="padding:6px; text-align:right; width:170; background-color:#ffffff; border:1px solid #e0e0e0;font-family:arial;">
			{$order->discount}&nbsp;%
		</td>
	</tr>
	{/if}

	{if $order->coupon_discount>0}
	<tr>
		<td style="padding:6px; width:100; padding:6px; background-color:#ffffff; border:1px solid #e0e0e0;font-family:arial;"></td>
		<td style="padding:6px; background-color:#f0f0f0; border:1px solid #e0e0e0;font-family:arial;">
			{$lang->coupon} {$order->coupon_code}
		</td>
		<td align=right style="padding:6px; text-align:right; width:170; background-color:#ffffff; border:1px solid #e0e0e0;font-family:arial;">
			&minus;{$order->coupon_discount}&nbsp;{$currency->sign}
		</td>
	</tr>
	{/if}
	
	{if $order->weight>0}
	<tr>
		<td style="padding:6px; width:100; padding:6px; background-color:#ffffff; border:1px solid #e0e0e0;font-family:arial;"></td>
		<td style="padding:6px; background-color:#f0f0f0; border:1px solid #e0e0e0;font-family:arial;">
			{$lang->weight}
		</td>
		<td align=right style="padding:6px; text-align:right; width:170; background-color:#ffffff; border:1px solid #e0e0e0;font-family:arial;">
			{$order->weight} {$settings->weight_units}
		</td>
	</tr>
	{/if}

	{if $delivery && !$order->separate_delivery}
	<tr>
		<td style="padding:6px; width:100; padding:6px; background-color:#ffffff; border:1px solid #e0e0e0;font-family:arial;"></td>
		<td style="padding:6px; background-color:#f0f0f0; border:1px solid #e0e0e0;font-family:arial;">
			{$delivery->name}
		</td>
		<td align="right" style="padding:6px; text-align:right; width:170; background-color:#ffffff; border:1px solid #e0e0e0;font-family:arial;">
			{$order->delivery_price|convert:$currency->id}&nbsp;{$currency->sign}
		</td>
	</tr>
	{/if}
	
	<tr>
		<td style="padding:6px; width:100; padding:6px; background-color:#ffffff; border:1px solid #e0e0e0;font-family:arial;"></td>
		<td style="padding:6px; background-color:#f0f0f0; border:1px solid #e0e0e0;font-family:arial;font-weight:bold;">
			{$lang->total}
		</td>
		<td align="right" style="padding:6px; text-align:right; width:170; background-color:#ffffff; border:1px solid #e0e0e0;font-family:arial;font-weight:bold;">
			{$order->total_price|convert:$currency->id}&nbsp;{$currency->sign}
		</td>
	</tr>
</table>

<br>
{$lang->status_order_link}<br>
<a href="{$config->root_url}/order/{$order->url}">{$config->root_url}/order/{$order->url}</a>
<br>