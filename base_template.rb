run "echo TODO > README"

if yes?("Do you want to use RSpec?")
  plugin "rspec", :git => "git:"
end

if yes?("Do you want to use jrails?")
  plugin "jrails", :git => "git://github.com/aaronchi/jrails.git"
end

if yes?("Do you want to use formtastic?")
  gem "formtastic"
  rake "gems:install"
  rake "gems:unpack"
  generate "formtastic"
end

if yes?("Do you want to use thoughtbot-clearance?")
  gem "thoughtbot-clearance",
    :lib     => 'clearance',
    :source  => 'http://gems.github.com',
    :version => '>= 0.8.2'
  rake "gems:install"
  rake "gems:unpack"
  generate "clearance"
  generate "clearance_views"
  rake "db:migrate"
end

if yes?("Do you want to generate nifty_layout?")
  generate "nifty_layout"
end

generate :controller, "top", "index"
route "map.root :controller => :top"

file ".gems", <<-END
rails -v 2.3.8
pg
END

file ".gitignore", <<-END
.DS_Store
*.swp
log/*.log
log/*.pid
tmp/**/*
tmp/*
config/database.yml
db/*.sqlite3
config/environments/development.rb
*.tmproj
coverage
END

run "touch tmp/.gitignore log/.gitignore vendor/.gitignore"
run "cp config/database.yml config/example_database.yml"
run "rm public/index.html"

# Replace application layout
file "app/views/layouts/application.html.erb",
%q{<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
  "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <title><%= h(yield(:title) || "Untitled") %></title>
    <%= stylesheet_link_tag 'application', 'formtastic', 'formtastic_changes' %>
    <%= yield(:head) %>
  </head>
  <body>
    <div id="container">
      <%- flash.each do |name, msg| -%>
        <%= content_tag :div, msg, :id => "flash_#{name}" %>
      <%- end -%>
      
      <%- if show_title? -%>
        <h1><%=h yield(:title) %></h1>
      <%- end -%>
      
      <%= yield %>
    </div>
  </body>
</html>
}

file "config/locales/ja.rb",
%q{{
  :'ja' => {
    # date and time formats
    :date => {
      :formats => {
        :default      => "%Y年%m月%d日",
        :short        => "%Y/%m/%d",
        :long         => "%B %e, %Y",
        :long_ordinal => lambda { |date| "%B #{date.day}, %Y" },
        :only_day     => "%e"
      },
      :day_names => %w(日曜日 月曜日 火曜日 水曜日 木曜日 金曜日 土曜日),
      :abbr_day_names => %w(日 月 火 水 木 金 土),
      :month_names => [nil] + %w(1 2 3 4 5 6 7 8 9 10 11 12),
      :abbr_month_names => [nil] + %w(1 2 3 4 5 6 7 8 9 10 11 12),
      :order => [:year, :month, :day]
    },
    :time => {
      :formats => {
        :default      => "%Y年%m月%d日 %H時%M分",
        :time         => "%H:%M",
        :short        => "%Y/%m/%d %H:%M",
        :long         => "%B %d, %Y %H:%M",
        :long_ordinal => lambda { |time| "%B #{time.day}, %Y %H:%M" },
        :only_second  => "%S"
      },
      :am => '',
      :pm => ''
    },

    # date helper distance in words
    :datetime => {
      :distance_in_words => {
        :half_a_minute       => '30分',
        :less_than_x_seconds => '{{count}} 秒以下',
        :x_seconds           => '{{count}} 秒',
        :less_than_x_minutes => '{{count}} 分以下',
        :x_minutes           => '{{count}} 分',
        :about_x_hours       => '約 {{count}} 時間',
        :x_days              => '{{count}} 日',
        :about_x_months      => '約 {{count}} ヶ月',
        :x_months            => '{{count}} ヶ月',
        :about_x_years       => '約　{{count}} 年',
        :over_x_years        => '{{count}} 年以上'
      }
    },

    # numbers
    :number => {
      :format => {
        :precision => 3,
        :separator => '.',
        :delimiter => ','
      },
      :currency => {
        :format => {
          :unit => '¥',
          :precision => 2,
          :format => '%u%n'
        }
      }
    },

    # Active Record
    :activerecord => {
      :errors => {
        :template => {
          :header => {
            :one => "{{model}}でエラーが発生しました。",
            :other => "{{model}}で{{count}}個のエラーが発生しました。"
          },
          :body => "以下のメッセージを確認してください:"
        },
        :messages => {
          :inclusion => "は、リストに含まれていません。",
          :exclusion => "は、有効な値ではありません。",
          :invalid => "は、妥当な値ではありません。",
          :confirmation => "が一致していません。",
          :accepted  => "は、入力できません。",
          :empty => "何も入力されていません。",
          :blank => "を入力してください。",
          :too_long => "は{{count}}文字以下にしてください",
          :too_short => "には{{count}}文字以上入力してください",
          :wrong_length => "は、桁数が合っていません。({{count}}桁必要です)",
          :taken => "は既に使われています。",
          :not_a_number => "は、数字ではありません。",
          :greater_than => "は、{{count}}文字を超えて入力されています。",
          :greater_than_or_equal_to => "は、{{count}}文字以上入力されています。",
          :equal_to => "は、{{count}}と同値です。",
          :less_than => "は、{{count}}文字未満です。",
          :less_than_or_equal_to => "は、{{count}}文字以下で入力されています。",
          :odd => "に奇数が入力されています。",
          :even => "に偶数が入力されています。"
        }
      }
    }
  }
}
}

git :init
git :add => "."
git :commit => "-m 'initial commit'"
