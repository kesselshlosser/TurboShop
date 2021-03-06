{* List products *}

{* Canonical page address *}
{if $set_canonical || $self_canonical}
    {if $category && $brand}
        {$canonical="/catalog/{$category->url}/{$brand->url}" scope=global}
    {elseif $category}
        {$canonical="/catalog/{$category->url}" scope=global}
    {elseif $brand}
        {$canonical="/brands/{$brand->url}" scope=global}
	{elseif $page}
        {$canonical="/{$page->url}" scope=global}	
    {elseif $keyword}
        {$canonical="/products?keyword={$keyword|escape}" scope=global}
    {else}
        {$canonical="/products" scope=global}
    {/if}
{/if}

<!-- Breadcrumb /-->
{$level = 1}
<nav class="mt-4" aria-label="breadcrumb">
    <ol itemscope itemtype="https://schema.org/BreadcrumbList" class="breadcrumb bg-light">
		<li itemprop="itemListElement" itemscope itemtype="https://schema.org/ListItem" class="breadcrumb-item">
			<a itemprop="item" href="{$lang_link}"><span itemprop="name">{$lang->home}</span></a>
			<meta itemprop="position" content="{$level++}" />
		</li>
		{if $page && !$category}
			<li itemprop="itemListElement" itemscope itemtype="http://schema.org/ListItem" class="breadcrumb-item active" aria-current="page">
				<a itemprop="item" href="{$lang_link}{$page->url}"><span itemprop="name">{$page->header|escape}</span></a>
				<meta itemprop="position" content="{$level++}" />
			</li>
		{/if}
        {if $category}
			<li itemprop="itemListElement" itemscope itemtype="http://schema.org/ListItem" class="breadcrumb-item active" aria-current="page">
				<a itemprop="item" href="{$lang_link}catalog"><span itemprop="name">{$lang->catalog}</span></a>
				<meta itemprop="position" content="{$level++}" />
			</li>
			{foreach $category->path as $cat}
				<li itemprop="itemListElement" itemscope itemtype="https://schema.org/ListItem" class="breadcrumb-item">
					<a itemprop="item" href="{$lang_link}catalog/{$cat->url}"><span itemprop="name">{$cat->name|escape}</span></a>
					<meta itemprop="position" content="{$level++}" />
				</li>
			{/foreach}  
			{if $brand}
				<li itemprop="itemListElement" itemscope itemtype="https://schema.org/ListItem" class="breadcrumb-item">
				<a itemprop="item" href="{$lang_link}catalog/{$cat->url}/{$brand->url}"><span itemprop="name">{$brand->name|escape}</span></a>
					<meta itemprop="position" content="{$level++}" />
				</li>
			{/if}
			{if $page}
			<li itemprop="itemListElement" itemscope itemtype="http://schema.org/ListItem" class="breadcrumb-item active" aria-current="page">
				<a itemprop="item" href="{$lang_link}{$page->url}"><span itemprop="name">{$page->header|escape}</span></a>
				<meta itemprop="position" content="{$level++}" />
			</li>
			{/if}
        {elseif $brand}
			<li itemprop="itemListElement" itemscope itemtype="http://schema.org/ListItem" class="breadcrumb-item active" aria-current="page">
				<a itemprop="item" href="{$lang_link}brands"><span itemprop="name">{$lang->index_brands}</span></a>
				<meta itemprop="position" content="{$level++}" />
			</li>
			<li itemprop="itemListElement" itemscope itemtype="https://schema.org/ListItem" class="breadcrumb-item">
			<a itemprop="item" href="{$lang_link}brands/{$brand->url}"><span itemprop="name">{$brand->name|escape}</span></a>
				<meta itemprop="position" content="{$level++}" />
			</li>
		{elseif $wishlist}
			<li itemprop="itemListElement" itemscope itemtype="https://schema.org/ListItem" class="breadcrumb-item active">
				<a itemprop="item" href="{$lang_link}wishlist/"><span itemprop="name">{$lang->compare}</span></a>
				<meta itemprop="position" content="{$level++}" />
			</li>
        {elseif $keyword}
			<li itemprop="itemListElement" itemscope itemtype="https://schema.org/ListItem" class="breadcrumb-item active">
				<a itemprop="item" href="{$lang_link}products?keyword={$keyword|escape}"><span itemprop="name">{$lang->search}</span></a>
				<meta itemprop="position" content="{$level++}" />
			</li>
        {/if}
	</ol>
</nav>
<!-- Breadcrumb #End /-->

{* Page title *}
{if $keyword}
	<h1 class="my-4">{$lang->search} {$keyword|escape}</h1>
{elseif $page}
	<h1 class="my-4">{$page->name|escape}</h1>
{else}
	<h1 class="my-4">{if $category->name_h1}{$category->name_h1|escape}{else}{$category->name|escape}{/if} {$brand->name|escape} {$filter_meta->h1|escape}</h1>
{/if}

{if $page->url=='catalog'}
	{include file='catalog.tpl'}
{else}
	{if $products}
	<div class="btn-toolbar justify-content-between mb-4" role="toolbar" aria-label="Toolbar with button groups">
		<a class="btn btn-light dropdown-toggle" href="#" role="button" id="dropdownMenuLink" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
			{$lang->sort_by}
		</a>
		{if $keyword || $page || $brand}
		<div class="dropdown-menu" aria-labelledby="dropdownMenuLink">
			<a class="dropdown-item {if $sort=='position'}active{/if}" href="{url sort=position page=null}">{$lang->default}</a>
			<a class="dropdown-item {if $sort=='name'}active{/if}" href="{url sort=name page=null}">{$lang->by_name_from_a_to_z}</a>
			<a class="dropdown-item {if $sort=='name_desc'}active{/if}" href="{url sort=name_desc page=null}">{$lang->by_name_from_z_to_a}</a>
			<a class="dropdown-item {if $sort=='price'}active{/if}" href="{url sort=price page=null}">{$lang->cheap_to_expensive}</a>
			<a class="dropdown-item {if $sort=='price_desc'}active{/if}" href="{url sort=price_desc page=null}">{$lang->from_expensive_to_cheap}</a>
			<a class="dropdown-item {if $sort=='rating'}active{/if}" href="{url sort=rating page=null}">{$lang->by_rating}</a>
		</div>
		{else}
		<div class="dropdown-menu" aria-labelledby="dropdownMenuLink">
			<a class="dropdown-item {if $sort=='position'}active{/if}" href="{furl sort=position page=null}">{$lang->default}</a>
			<a class="dropdown-item {if $sort=='name'}active{/if}" href="{furl sort=name page=null}">{$lang->by_name_from_a_to_z}</a>
			<a class="dropdown-item {if $sort=='name_desc'}active{/if}" href="{furl sort=name_desc page=null}">{$lang->by_name_from_z_to_a}</a>
			<a class="dropdown-item {if $sort=='price'}active{/if}" href="{furl sort=price page=null}">{$lang->cheap_to_expensive}</a>
			<a class="dropdown-item {if $sort=='price_desc'}active{/if}" href="{furl sort=price_desc page=null}">{$lang->from_expensive_to_cheap}</a>
			<a class="dropdown-item {if $sort=='rating'}active{/if}" href="{furl sort=rating page=null}">{$lang->by_rating}</a>
		</div>
		{/if}
		<div class="btn-group" role="group" aria-label="First group">
			<button onclick="document.cookie='view=grid;path=/';document.location.reload();" type="button" class="btn btn-light {if $smarty.cookies.view == 'grid'}active{/if}"><i class="fa fa-th"></i></button>
			<button onclick="document.cookie='view=list;path=/';document.location.reload();" type="button" class="btn btn-light {if $smarty.cookies.view == 'list'}active{/if}"><i class="fa fa-th-list"></i></button>
		</div>
	</div>
	<div class="row">
		{if $smarty.cookies.view == 'list'}
		<main class="col-md-12">
			{include file='list.tpl'}
			{if $keyword || $page}
				{include file='pagination.tpl'}
			{else}
				{include file='chpu_pagination.tpl'}
			{/if}
		</main>
		{else} 
		{foreach $products as $product}
			{include file='grid.tpl'}
		{/foreach}
		<main class="col-md-12">
			{if $keyword || $page}
				{include file='pagination.tpl'}
			{else}
				{include file='chpu_pagination.tpl'}
			{/if}
		</main>
		{/if}
	</div>
	{else}
	<div class="alert alert-warning mt-4" role="alert">
		{$lang->no_products_found}
	</div>
	{/if}
{/if}

{* Page description (if set) *}
{$page->body}

{if $current_page_num==1}
{* Category description *}
{$category->description}
{/if}

{if $current_page_num==1}
{* Brand Description *}
{$brand->description}
{/if}