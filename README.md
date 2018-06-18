## Day 07 : form helper, flash, toastr_rails



### 1. Model과 Controller 생성

### Model

`$ rails g model board contents, ip_address`

`$ rails g model board contents:text ip_address`

- contents, ip_address라는 변수를 가진 `board`테이블이 생성됨

- type을 명시하지 않으면 기본 t.string으로 생성됨



`$ rails d model board`

- 테이블을 삭제할 때 사용함 (generate ↔ destroy)



### Controller

`$ rake routes` : routes가 잘 적용되었는지 확인할 수 있음





### 2. form helper 

: view helper의 일종으로, 간단한 Ruby tag로 html 코드를 구현함

참고 자료 : http://guides.rubyonrails.org/form_helpers.html, https://www.slideshare.net/JunghyunPark39/ruby-on-rails-view-helper-top4



*적용해보기*

```erb
#form helper
<%= submit_tag("tweet") %>
# html
<input type="submit" value="tweet">
```
*form helper 실행시 개발자도구 Elements*

<input type="submit" name="commit" value="tweet" data-disable-with="tweet">

*html 실행시 개발자도구 Elements*

<input type="submit" value="tweet">

```erb
#form helper
<%= text_area_tag(:contents, params[:contents], placeholder: "What's happening?", size: "24x6") %>
# html
<textarea placeholder="What's happening?"></textarea>
```
*form helper 실행시 개발자도구 Elements*

<textarea name="contents" id="contents" cols="24" rows="6"></textarea>

*html 실행시 개발자도구 Elements*

<textarea placeholder="What's happening?"></textarea>

```erb
#form helper
<%= link_to tweet.contents, "/tweet/#{tweet.id}", class: "list-gorup-tiem list-gorup-item" %>
# html
<a class="list-group-item list-group-item-action" href="/tweet/<%=tweet.id %>"><%=tweet.contents%><small>(<%= tweet.ip_address %>)</small></a>
    
```


### 3. flash

참고자료: https://agilewarrior.wordpress.com/2014/04/26/how-to-add-a-flash-message-to-your-rails-page/



##### 쿠키란?

- client와 Server가 주고 받은 request & response는 한 세트로 생각하여 각 세트가 독립적이다.  그래서 새로운 request가 들어오면 '상태'가 저장되지 않고 사라지는데, 이때 정보를 보다 더 유지하고자 사용하는 것이 쿠키이다.

- 쿠키는 server에 저장되는 것이 아닌, **browser에 저장됨** (사용자 쪽에 저장되어 있음)
  - 로그아웃, 시간초과로 인한 강제 로그아웃, 브라우저 변경시 사라짐
  - 휘발성
- `cookie`를 암호화한 것이 `session` (hash형태로 저장됨)





### 4. toastr_rails 사용해보기

참고자료 : https://github.com/d4be4st/toastr_rails



`$ gem 'toastr_rails'` : Gemfile에 추가하기 + `bundle install` + 서버 재시작

```js
//= require jquery
//= require jquery_ujs
//= require popper
//= require bootstrap
//= require toastr_rails
//= require turbolinks
//= require_tree .

toastr.options = {
  "closeButton": true,
  "debug": false,
  "progressBar": true,
  "positionClass": "toast-top-right",
  "showDuration": "300",
  "hideDuration": "1000",
  "timeOut": "5000",
  "extendedTimeOut": "1000",
  "showEasing": "swing",
  "hideEasing": "linear",
  "showMethod": "fadeIn",
  "hideMethod": "fadeOut"
};
```





#### 간단과제. 가짜 twitter 만들기

1. Model, db 구축

```ruby
class CreateBoards < ActiveRecord::Migration[5.0]
  def change
    create_table :boards do |t|
      t.text "contents"
      t.string "ip_address"

      t.timestamps
    end
  end
end
```



2. routes 생성

```ruby
Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

    root 'tweet#index'
    
    get '/tweet' => 'tweet#index'
    get '/tweet/new' => 'tweet#new'
    get 'tweet/:id' => 'tweet#show'
    post'/tweet/create' => 'tweet#create'
    
    get '/tweet/:id/edit' => 'tweet#edit'
    post '/tweet/:id/update' => 'tweet#update'
    get '/tweet/:id/destroy' => 'tweet#destroy'
end
```



3. Controller 생성

```ruby
class TweetController < ApplicationController
    def index
        @tweets = Board.all
        cookies[:user_name] = "Q"
    end
    
    def show
        @tweet = Board.find(params[:id])
    end
    
    def new
    end
    
    def create
        tweet = Board.new
        tweet.contents = params[:contents]
        tweet.ip_address = request.ip
        tweet.save
        flash[:success] = "새 글이 등록되었습니다."
        redirect_to "/tweet/#{tweet.id}"
    end
    
    def edit
        @tweet = Board.find(params[:id])
    end
    
    def update
        tweet = Board.find(params[:id])
        tweet.contents = params[:contents]
        tweet.save
        flash[:success] = "글이 수정됐습니다."
        redirect_to "/tweet"
    end
    
    def destroy
        tweet = Board.find(params[:id])
        tweet.destroy
        flash[:error] = "글이 삭제됐습니다."
        redirect_to "/tweet"
    end
    
end
```



4. view 구축하기

*views/tweet/index.html.erb*

```erb
<div class="list-group">
    <% @tweets.each do |tweet| %>
        <%= link_to truncate(tweet.contents, length:13), "/tweet/#{tweet.id}", class: "list-group-item list-group-item-action" %>
        <!-- <%=tweet.created_at %> -->
    <% end %>
</div>
```

- <%= link_to truncate(tweet.contents, length:13), "/tweet/#{tweet.id}", class: "list-group-item list-group-item-action" %>

  - <%=link_to %> : <a>와 같음 

  - truncate(  ) : tweet.contents를 13글자만 보여줌
  -  "/tweet/#{tweet.id}" : 해당 경로로 이동
  - class: "list-group-item list-group-item-action" : bootstrap 적용



*views/tweet/show.html.erb*

```erb
<br/><br/>
<div class="container">
    <div class="text-center">
        <img class="avatar js-action-profile-avatar" src="https://abs.twimg.com/sticky/default_profile_images/default_profile_bigger.png" alt="">
    </div>

<div class="text-center">
    <h3><%=@tweet.contents%></h3>
    <a class="btn btn-outline-warning" href="/tweet/<%= @tweet.id %>/edit">modify</a>
    <a class="btn btn-outline-danger" href="/tweet/<%= @tweet.id %>/destroy">delete</a>
    </div>
</div>
```



*views/tweet/new.html.erb*

```erb
<%= form_tag('/tweet/create') do %>
<div class="text-center">
        <h3 class="modal-title" id="Tweetstorm-dialog-header">Compose new Tweet</h3><br/>
    <%= text_area_tag(:contents, params[:contents], placeholder: "What's happening?", size: "24x6") %>
    <%= submit_tag "tweet", class: "btn btn-primary" %>
<% end %>
</div>
```

- <%= text_area_tag(:contents, params[:contents], placeholder: "What's happening?", size: "24x6") %>
  - <%=text_area_tage %> : `textarea`태그와 동일함

- <%= submit_tag "tweet", class: "btn btn-primary" %>
  - <%=submit_tag %> : `input type="submit"`과 동일함



*views/tweet/edit.html.erb*

```erb
<div class="container">
    <%= form_tag("/tweet/#{@tweet.id}/update") do %>
        <%= text_area_tag(:contents, @tweet.contents, size: "24x6") %>
        <input type="submit" value="re_tweet">
    <% end %>
</div>
```



5. 모든 view에 공통적으로 적용될 css 적용

```html
<!DOCTYPE html>
<html>
  <head>
    <title>Twitter01App</title>
    <%= csrf_meta_tags %>

    <%= stylesheet_link_tag    'application', media: 'all', 'data-turbolinks-track': 'reload' %>
    <%= javascript_include_tag 'application', 'data-turbolinks-track': 'reload' %>
  </head>

  <body>
    <div class="d-flex flex-column flex-md-row align-items-center p-3 px-md-4 mb-3 bg-white border-bottom box-shadow">
      <h5 class="my-0 mr-md-auto font-weight-normal">twitter</h5>
      <!--<nav class="my-2 my-md-0 mr-md-3">-->
        <a href="/tweet"><img src="https://image.flaticon.com/icons/svg/733/733579.svg"></a>
        <a class="p-10 text-dark" href="/"><img scr="https://image.flaticon.com/icons/svg/34/34205.svg">Home</a>
        <a class="p-10 text-dark" href="#">Notifications</a>
        <input class="search-input" type="text" id="search-query" placeholder="Search Twitter" name="q" autocomplete="off" spellcheck="false" aria-autocomplete="list" aria-expanded="false" aria-owns="typeahead-dropdown-1">
        
      <!--</nav>-->
      <a class="btn btn-outline-primary" href="#">Sign up</a>&nbsp;&nbsp; 
      <a class="btn btn-outline-primary" href="/tweet/new">tweet</a>

    </div>
    <div class="container">
      <% flash.each do |k, v| %>
        <script>
          toastr.<%= k %>("<%= v %>");
        </script>
      <% end %>
      <%= yield %>
    </div>  
  </body>
</html>
```





> git master 변경하기 : 'show hidden file' - '.git' - 'config' 에서 주소 수정하기