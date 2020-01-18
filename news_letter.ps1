#BBC news

#https://superwidgets.wordpress.com/tag/read-html-via-powershell-powershell/
$Uri = "https://www.bbc.com/news/world"
$Html = Invoke-WebRequest -Uri $Uri

#Headline
$headline_title = ($Html.ParsedHtml.getElementsByTagName("h3") | where{$_.className -eq 'gs-c-promo-heading__title gel-paragon-bold gs-u-mt+ nw-o-link-split__text'}).innerText
$headline_summary = ($Html.ParsedHtml.getElementsByTagName("p") | where{$_.className -eq 'gs-c-promo-summary gel-long-primer gs-u-mt nw-c-promo-summary'}).innerText
$headline_link = ($Html.ParsedHtml.getElementsByTagName("a") | where{$_.className -eq 'gs-c-promo-heading gs-o-faux-block-link__overlay-link gel-paragon-bold gs-u-mt+ nw-o-link-split__anchor'}).href
$src = ($Html.ParsedHtml.getElementsByTagName("div") | where{$_.className -eq 'gs-o-responsive-image gs-o-responsive-image--16by9 gs-o-responsive-image--lead'}).innerHTML
$src_pattern = '(src=\")(.*?)\"'
$headline_img = ([regex]$src_pattern).Matches($src) |  ForEach-Object { $_.Groups[2].Value }

#Other articles
$news_titles = @($Html.ParsedHtml.getElementsByTagName("a") | where{$_.className -eq 'gs-c-promo-heading gs-o-faux-block-link__overlay-link gel-pica-bold nw-o-link-split__anchor'}).innerText
$news_summary = @($Html.ParsedHtml.getElementsByTagName("p") | where{$_.className -eq 'gs-c-promo-summary gel-long-primer gs-u-mt nw-c-promo-summary gs-u-display-none gs-u-display-block@m'}).innerText
$news_links = @($Html.ParsedHtml.getElementsByTagName("a") | Where{$_.className -eq 'gs-c-promo-heading gs-o-faux-block-link__overlay-link gel-pica-bold nw-o-link-split__anchor'}).href
$news_time = @($Html.ParsedHtml.getElementsByTagName("span") | Where{$_.className -eq 'qa-status-date-output'}).innerText
$news_theme = @($Html.ParsedHtml.getElementsByTagName("a") | Where{$_.className -eq 'gs-c-section-link gs-c-section-link--truncate nw-c-section-link nw-o-link nw-o-link--no-visited-state'}).innerText

#Get images
$srcr_pattern = '(?i)src=\"(.*?)\"'
$news_img = @([regex]$srcr_pattern ).Matches(($Html.ParsedHtml.getElementsByTagName("div") | where{$_.className -eq 'gs-o-responsive-image gs-o-responsive-image--16by9'}).innerHTML) | ForEach-Object { $_.Groups[1].Value }

#remove links with '{width}'
$news_img_clean = @()
ForEach ($img in $news_img){
    if($img -NotMatch "{width}"){
        $news_img_clean = $news_img_clean += $img
    }
}

$src_path = "C:\Users\ham-d\Documents\daily_news_letter.html"
$src_dest = "C:\Users\ham-d\Documents\daily_news_letter11.html"

#Replace placeholders in html
(Get-Content $src_path).replace('$$date_time$$', (Get-Date -DisplayHint Date).ToString()) | Set-Content $src_dest
(Get-Content $src_dest).replace('$$news_main_title$$', $headline_title[0]) | Set-Content $src_dest
(Get-Content $src_dest).replace('$$news_main_summary$$', $headline_summary[0]) | Set-Content $src_dest
(Get-Content $src_dest).replace('$$news_main_link$$', ($headline_link[0]).replace("about:", "https://www.bbc.com")) | Set-Content $src_dest
(Get-Content $src_dest).replace('$$news_main_img$$', $headline_img[0]) | Set-Content $src_dest
(Get-Content $src_dest).replace('$$news_main_time$$', $news_time[1]) | Set-Content $src_dest
(Get-Content $src_dest).replace('$$news_main_theme$$', $news_theme[1]) | Set-Content $src_dest

For ($i=0; $i -le 5; $i++){
    (Get-Content $src_dest).replace(-join('$$news_title_', $i , '$$'), $news_titles[$i]) | Set-Content $src_dest
    (Get-Content $src_dest).replace(-join('$$news_summary_', $i , '$$'), $news_summary[$i]) | Set-Content $src_dest
    (Get-Content $src_dest).replace(-join('$$news_link_', $i , '$$'), ($news_links[$i]).replace("about:", "https://www.bbc.com")) | Set-Content $src_dest
    (Get-Content $src_dest).replace(-join('$$news_img_', $i , '$$'), $news_img_clean[$i]) | Set-Content $src_dest
    (Get-Content $src_dest).replace(-join('$$news_time_', $i , '$$'), $news_time[$i+2]) | Set-Content $src_dest
    (Get-Content $src_dest).replace(-join('$$news_theme_', $i , '$$'), $news_theme[$i+2]) | Set-Content $src_dest
}


#Hacker news

#https://superwidgets.wordpress.com/tag/read-html-via-powershell-powershell/
$Uri = "https://thehackernews.com/"
$Html = Invoke-WebRequest -Uri $Uri

$hn_titles = @($Html.ParsedHtml.getElementsByTagName("h2") | where{$_.className -eq 'home-title'}).innerText
#echo $hn_titles
$hn_summary = @($Html.ParsedHtml.getElementsByTagName("div") | where{$_.className -eq 'home-desc'}).innerText
#echo $hn_summary
$srcr_pattern = '(?i)src=\"(.*?)\"'
$hn_img = @([regex]$srcr_pattern ).Matches(($Html.ParsedHtml.getElementsByTagName("div") | where{$_.className -eq 'img-ratio'}).innerHTML) |  ForEach-Object { if($_ -NotMatch "data:image"){ $_.Groups[1].Value} }
#echo $hn_img
$hn_links = @($Html.ParsedHtml.getElementsByTagName("a") | Where{$_.className -eq 'story-link'}).href

$srcr_pattern = '<\/i>(.*)<span>'
$hn_time = @([regex]$srcr_pattern ).Matches(($Html.ParsedHtml.getElementsByTagName("div") |  Where{$_.className -eq 'item-label'}).innerHTML) |  ForEach-Object { $_.Groups[1].Value }
#echo $hn_time


For ($i=0; $i -le 5; $i++){
    #if ($i -eq 0) {(Get-Content $src_path).replace(-join('$$hn_title_', $i , '$$'), $hn_titles[$i]) | Set-Content $src_dest}else{
    (Get-Content $src_dest).replace(-join('$$hn_title_', $i , '$$'), $hn_titles[$i]) | Set-Content $src_dest #}
    (Get-Content $src_dest).replace(-join('$$hn_summary_', $i , '$$'), $hn_summary[$i]) | Set-Content $src_dest
    (Get-Content $src_dest).replace(-join('$$hn_link_', $i , '$$'), $hn_links[$i]) | Set-Content $src_dest
    (Get-Content $src_dest).replace(-join('$$hn_img_', $i , '$$'), $hn_img[$i]) | Set-Content $src_dest
    (Get-Content $src_dest).replace(-join('$$hn_time_', $i , '$$'), $hn_time[$i]) | Set-Content $src_dest
}
