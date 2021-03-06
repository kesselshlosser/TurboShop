<div class="col-md-6 col-lg-4">
	<figure class="card card-product-grid product">
		<div class="img-wrap"> 
			<span class="badges">
				{if $product->variant->compare_price > 0}<span class="notify-badge badge badge-danger">{$lang->badge_sale}</span>{/if}
				{if $product->featured}<span class="notify-badge badge badge-primary">{$lang->badge_featured}</span>{/if}
				{if $product->is_new}<span class="notify-badge badge badge-warning">{$lang->badge_new}</span>{/if}
				{if $product->is_hit}<span class="notify-badge badge badge-success">{$lang->badge_hit}</span>{/if}
			</span>
			{if $product->image}
				<a class="image" href="{$lang_link}products/{$product->url}"><img src="{$product->image->filename|resize:240:240}" alt="{$product->name|escape}"/></a>
			{else}
				<a class="image" href="{$lang_link}products/{$product->url}"><img style="width: 170px; height: 170px;" src="design/{$settings->theme|escape}/images/no-photo.svg" alt="{$product->name|escape}"/></a>
			{/if}
		</div> <!-- img-wrap.// -->
		<figcaption class="info-wrap">
			<div class="fix-height">
				<a data-product="{$product->id}" href="{$lang_link}products/{$product->url}" class="title">{$product->name|escape}</a>
				<div class="rating-wrap mb-2">
					<ul class="rating-stars">
						<li style="width:{$product->rating*100/5|string_format:"%.0f"}%" class="stars-active"> 
							<i class="fa fa-star"></i> 
							<i class="fa fa-star"></i> 
							<i class="fa fa-star"></i> 
							<i class="fa fa-star"></i> 
							<i class="fa fa-star"></i> 
						</li>
						<li>
							<i class="fa fa-star"></i> 
							<i class="fa fa-star"></i> 
							<i class="fa fa-star"></i> 
							<i class="fa fa-star"></i> 
							<i class="fa fa-star"></i> 
						</li>
					</ul>
					<div class="label-rating">{$product->votes|string_format:"%.0f"} {$lang->of_vote}</div>
				</div>
				<div class="price-wrap mt-2">
					{if $product->variants|count > 0}
					{if $product->variant->compare_price > 0}<del class="price-old"><small><span class="compare_price">{$product->variant->compare_price|convert}</span> {$currency->sign|escape}</small></del>{/if}  
					<span class="price">{$product->variant->price|convert} {$currency->sign|escape}</span>
					{/if}
				</div> <!-- price-wrap.// -->
			</div>
			<div class="btn-toolbar justify-content-between">
				{if $product->variants|count > 0}
				<form class="variants" action="{$lang_link}cart">
					{foreach $product->variants as $v}
					<input id="featured_{$v->id}" name="variant" value="{$v->id}" type="radio" class="variant_radiobutton" {if $v@first}checked{/if} style="display:none;"/>
					{/foreach}
					<input type="submit" data-result-text="{$lang->added_cart}" class="btn btn-primary" value="{$lang->add_cart}" title="{$lang->add_cart}"/>
				</form>
				{else}
				{$lang->not_available}
				{/if}
				<div class="btn-group" role="group" aria-label="First group">
					{if $wishlist}
					<a class="btn btn-light"  href='{$lang_link}wishlist/remove/{$product->url}'><i class="fa fa-heart text-danger"></i></a>
					{elseif $wishlist_products && in_array($product->url, $wishlist_products)}
					<a class="btn btn-light"  href='{$lang_link}wishlist'><i class="fa fa-heart text-danger"></i></a>
					{else}
					<a class="btn btn-light wishlist" href='{$lang_link}wishlist/{$product->url}'><i class="fa fa-heart text-secondary"></i></a>
					{/if}
					{if $smarty.session.compared_products && in_array($product->url, $smarty.session.compared_products)}
					<a class="btn btn-light" href='{$lang_link}compare'><i class="fa fa-chart-bar text-primary"></i></a>
					{else}
					<a class="btn btn-light compare" href='{$lang_link}compare/{$product->url}'><i class="fa fa-chart-bar text-secondary"></i></a>
					{/if}
				</div>
			</div>
		</figcaption>
	</figure>
</div>