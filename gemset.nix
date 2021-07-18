{
  actionmailer = {
    dependencies = ["actionpack" "actionview" "activejob" "mail" "rails-dom-testing"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "15j7dc2a03n75xqxpr6ymdc93i88hr97qnjlk0qpkdjdnyd5qr5g";
      type = "gem";
    };
    version = "4.2.6";
  };
  actionpack = {
    dependencies = ["actionview" "activesupport" "rack" "rack-test" "rails-dom-testing" "rails-html-sanitizer"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1xh89xyrn6w3ywl4db3fvkwkm3xhvdfl7w4v2s17l44h44ly1d5c";
      type = "gem";
    };
    version = "4.2.6";
  };
  actionview = {
    dependencies = ["activesupport" "builder" "erubis" "rails-dom-testing" "rails-html-sanitizer"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1jssa1qkyr1xavv36rkadg0wh5x4v21c215q4v65yc78rwxfwn47";
      type = "gem";
    };
    version = "4.2.6";
  };
  activejob = {
    dependencies = ["activesupport" "globalid"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "050g5g700l4i7nflb6j7zayivzb9jrx9ibvr0amfp4bfbd4vy9fi";
      type = "gem";
    };
    version = "4.2.6";
  };
  activemodel = {
    dependencies = ["activesupport" "builder"];
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ibi87w1a4ldx979cz9qrsffj08nh8x3k6hgjjpvc15slw796c22";
      type = "gem";
    };
    version = "4.2.6";
  };
  activerecord = {
    dependencies = ["activemodel" "activesupport" "arel"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1bjkfr7mrcrxy5m1ir50bfmkab3sha6jliy38n7wx92vvxfjikxz";
      type = "gem";
    };
    version = "4.2.6";
  };
  activesupport = {
    dependencies = ["i18n" "json" "minitest" "thread_safe" "tzinfo"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "03y5xk7xmmny3knkwilszd5w7pfh6qf9cib5mva88ni1g7r6s9hq";
      type = "gem";
    };
    version = "4.2.6";
  };
  ancestry = {
    dependencies = ["activerecord"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0rk7qbyiryz7xxigjmavxar9j3aw1g15f0bdmw2a0z936gn6c2zv";
      type = "gem";
    };
    version = "2.2.2";
  };
  arel = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1a270mlajhrmpqbhxcqjqypnvgrq4pgixpv3w9gwp1wrrapnwrzk";
      type = "gem";
    };
    version = "6.0.3";
  };
  bcrypt = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1d254sdhdj6mzak3fb5x3jam8b94pvl1srladvs53j05a89j5z50";
      type = "gem";
    };
    version = "3.1.11";
  };
  binding_of_caller = {
    dependencies = ["debug_inspector"];
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "15jg6dkaq2nzcd602d7ppqbdxw3aji961942w93crs6qw4n6h9yk";
      type = "gem";
    };
    version = "0.7.2";
  };
  builder = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "14fii7ab8qszrvsvhz6z2z3i4dw0h41a62fjr2h1j8m41vbrmyv2";
      type = "gem";
    };
    version = "3.2.2";
  };
  byebug = {
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1kbfcn65rgdhi72n8x9l393b89rvi5z542459k7d1ggchpb0idb0";
      type = "gem";
    };
    version = "9.0.6";
  };
  chunky_png = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0j0dngz6s0j3s3zaf9vrimjz65s9k7ad1c3xmmldr1vmz8sbd843";
      type = "gem";
    };
    version = "1.3.8";
  };
  coffee-rails = {
    dependencies = ["coffee-script" "railties"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1mv1kaw3z4ry6cm51w8pfrbby40gqwxanrqyqr0nvs8j1bscc1gw";
      type = "gem";
    };
    version = "4.1.1";
  };
  coffee-script = {
    dependencies = ["coffee-script-source" "execjs"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0rc7scyk7mnpfxqv5yy4y5q1hx3i7q3ahplcp4bq2g5r24g2izl2";
      type = "gem";
    };
    version = "2.4.1";
  };
  coffee-script-source = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1k4fg39rrkl3bpgchfj94fbl9s4ysaz16w8dkqncf2vyf79l3qz0";
      type = "gem";
    };
    version = "1.10.0";
  };
  concurrent-ruby = {
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1kb4sav7yli12pjr8lscv8z49g52a5xzpfg3z9h8clzw6z74qjsw";
      type = "gem";
    };
    version = "1.0.2";
  };
  debug_inspector = {
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "109761g00dbrw5q0dfnbqg8blfm699z4jj70l4zrgf9mzn7ii50m";
      type = "gem";
    };
    version = "0.0.2";
  };
  diff-lcs = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1vf9civd41bnqi6brr5d9jifdw73j9khc6fkhfl1f8r9cpkdvlx1";
      type = "gem";
    };
    version = "1.2.5";
  };
  erubis = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1fj827xqjs91yqsydf0zmfyw9p4l2jz5yikg3mppz6d7fi8kyrb3";
      type = "gem";
    };
    version = "2.7.0";
  };
  execjs = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1yz55sf2nd3l666ms6xr18sm2aggcvmb8qr3v53lr4rir32y1yp1";
      type = "gem";
    };
    version = "2.7.0";
  };
  globalid = {
    dependencies = ["activesupport"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "11plkgyl3w9k4y2scc1igvpgwyz4fnmsr63h2q4j8wkb48nlnhak";
      type = "gem";
    };
    version = "0.3.7";
  };
  i18n = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1i5z1ykl8zhszsxcs8mzl8d0dxgs3ylz8qlzrw74jb0gplkx6758";
      type = "gem";
    };
    version = "0.7.0";
  };
  jquery-rails = {
    dependencies = ["rails-dom-testing" "railties" "thor"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0prqyixv7j2qlq67qdr3miwcyvi27b9a82j51gbpb6vcl0ig2rik";
      type = "gem";
    };
    version = "4.2.1";
  };
  json = {
    groups = ["default" "development" "doc" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0lrirj0gw420kw71bjjlqkqhqbrplla61gbv1jzgsz6bv90qr3ci";
      type = "gem";
    };
    version = "2.5.1";
  };
  kgio = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1y6wl3vpp82rdv5g340zjgkmy6fny61wib7xylyg0d09k5f26118";
      type = "gem";
    };
    version = "2.10.0";
  };
  loofah = {
    dependencies = ["nokogiri"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "109ps521p0sr3kgc460d58b4pr1z4mqggan2jbsf0aajy9s6xis8";
      type = "gem";
    };
    version = "2.0.3";
  };
  mail = {
    dependencies = ["mime-types"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0c9vqfy0na9b5096i5i4qvrvhwamjnmajhgqi3kdsdfl8l6agmkp";
      type = "gem";
    };
    version = "2.6.4";
  };
  mime-types = {
    dependencies = ["mime-types-data"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0087z9kbnlqhci7fxh9f6il63hj1k02icq2rs0c6cppmqchr753m";
      type = "gem";
    };
    version = "3.1";
  };
  mime-types-data = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "04my3746hwa4yvbx1ranhfaqkgf6vavi1kyijjnw8w3dy37vqhkm";
      type = "gem";
    };
    version = "3.2016.0521";
  };
  mini_portile2 = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1y25adxb1hgg1wb2rn20g3vl07qziq6fz364jc5694611zz863hb";
      type = "gem";
    };
    version = "2.1.0";
  };
  minitest = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0300naf4ilpd9sf0k8si9h9sclkizaschn8bpnri5fqmvm9ybdbq";
      type = "gem";
    };
    version = "5.9.1";
  };
  nokogiri = {
    dependencies = ["mini_portile2"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "045xdg0w7nnsr2f2gb7v7bgx53xbc9dxf0jwzmh2pr3jyrzlm0cj";
      type = "gem";
    };
    version = "1.6.8.1";
  };
  pg = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0bplv27d0f8vwdj51967498pl1cjxq19hhcj4hdjr4h3s72l2z4j";
      type = "gem";
    };
    version = "0.19.0";
  };
  rack = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1374xyh8nnqb8sy6g9gcvchw8gifckn5v3bhl6dzbwwsx34qz7gz";
      type = "gem";
    };
    version = "1.6.5";
  };
  rack-test = {
    dependencies = ["rack"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0h6x5jq24makgv2fq5qqgjlrk74dxfy62jif9blk43llw8ib2q7z";
      type = "gem";
    };
    version = "0.6.3";
  };
  rails = {
    dependencies = ["actionmailer" "actionpack" "actionview" "activejob" "activemodel" "activerecord" "activesupport" "railties" "sprockets-rails"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0cxwwl1dx1ajihxq5lcri116dzalyafw8ck97achkbib1n62b6d1";
      type = "gem";
    };
    version = "4.2.6";
  };
  rails-assets-clipboard = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rails-assets.org"];
      sha256 = "1bl3halym2wsnlr6xj18k3nphddvzpss56xgdbv581qlyfhrwa8f";
      type = "gem";
    };
    version = "1.5.15";
  };
  rails-deprecated_sanitizer = {
    dependencies = ["activesupport"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0qxymchzdxww8bjsxj05kbf86hsmrjx40r41ksj0xsixr2gmhbbj";
      type = "gem";
    };
    version = "1.0.3";
  };
  rails-dom-testing = {
    dependencies = ["activesupport" "nokogiri" "rails-deprecated_sanitizer"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1v8jl6803mbqpxh4hn0szj081q1a3ap0nb8ni0qswi7z4la844v8";
      type = "gem";
    };
    version = "1.0.7";
  };
  rails-html-sanitizer = {
    dependencies = ["loofah"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "138fd86kv073zqfx0xifm646w6bgw2lr8snk16lknrrfrss8xnm7";
      type = "gem";
    };
    version = "1.0.3";
  };
  railties = {
    dependencies = ["actionpack" "activesupport" "rake" "thor"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0dh6wqs8pf3c2z5k75gg0wfw32vy0vj8p71zk01wmy4hh09pnr7i";
      type = "gem";
    };
    version = "4.2.6";
  };
  raindrops = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1syj5gdrgwzdqzc3p1bqg1wv6gn16s2iq8304mrglzhi7cyja73q";
      type = "gem";
    };
    version = "0.17.0";
  };
  rake = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0cnjmbcyhm4hacpjn337mg1pnaw6hj09f74clwgh6znx8wam9xla";
      type = "gem";
    };
    version = "11.3.0";
  };
  rdoc = {
    groups = ["default" "doc"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "13ba2mhqqcsp3k97x3iz9x29xk26rv4561lfzzzibcy41vvj1n4c";
      type = "gem";
    };
    version = "4.3.0";
  };
  rqrcode = {
    dependencies = ["chunky_png"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0h1pnnydgs032psakvg3l779w3ghbn08ajhhhw19hpmnfhrs8k0a";
      type = "gem";
    };
    version = "0.10.1";
  };
  rspec-core = {
    dependencies = ["rspec-support"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1nacs062qbr98fx6czf1vwppn1js956nv2c8vfwj6i65axdfs46i";
      type = "gem";
    };
    version = "3.5.4";
  };
  rspec-expectations = {
    dependencies = ["diff-lcs" "rspec-support"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0bbqfrb1x8gmwf8x2xhhwvvlhwbbafq4isbvlibxi6jk602f09gs";
      type = "gem";
    };
    version = "3.5.0";
  };
  rspec-mocks = {
    dependencies = ["diff-lcs" "rspec-support"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0nl3ksivh9wwrjjd47z5dggrwx40v6gpb3a0gzbp1gs06a5dmk24";
      type = "gem";
    };
    version = "3.5.0";
  };
  rspec-rails = {
    dependencies = ["actionpack" "activesupport" "railties" "rspec-core" "rspec-expectations" "rspec-mocks" "rspec-support"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0wfaj7sipiydml27y0qld303fzbj2d5a6qdpnabh41z3488vwkjm";
      type = "gem";
    };
    version = "3.5.2";
  };
  rspec-support = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "10vf3k3d472y573mag2kzfsfrf6rv355s13kadnpryk8d36yq5r0";
      type = "gem";
    };
    version = "3.5.0";
  };
  sass = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0dkj6v26fkg1g0majqswwmhxva7cd6p3psrhdlx93qal72dssywy";
      type = "gem";
    };
    version = "3.4.22";
  };
  sass-rails = {
    dependencies = ["railties" "sass" "sprockets" "sprockets-rails" "tilt"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0iji20hb8crncz14piss1b29bfb6l89sz3ai5fny3iw39vnxkdcb";
      type = "gem";
    };
    version = "5.0.6";
  };
  sdoc = {
    dependencies = ["json" "rdoc"];
    groups = ["doc"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0qhvy10vnmrqcgh8494m13kd5ag9c3sczzhfasv8j0294ylk679n";
      type = "gem";
    };
    version = "0.4.2";
  };
  spring = {
    dependencies = ["activesupport"];
    groups = ["development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1cdgy4lvxmnqqx3gza6wc9dpvwrg6cqmqv7m8ql9pqhxby7j6wwa";
      type = "gem";
    };
    version = "2.0.0";
  };
  sprockets = {
    dependencies = ["concurrent-ruby" "rack"];
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0jzsfiladswnzbrwqfiaj1xip68y58rwx0lpmj907vvq47k87gj1";
      type = "gem";
    };
    version = "3.7.0";
  };
  sprockets-rails = {
    dependencies = ["actionpack" "activesupport" "sprockets"];
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1zr9vk2vn44wcn4265hhnnnsciwlmqzqc6bnx78if1xcssxj6x44";
      type = "gem";
    };
    version = "3.2.0";
  };
  thor = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "08p5gx18yrbnwc6xc0mxvsfaxzgy2y9i78xq7ds0qmdm67q39y4z";
      type = "gem";
    };
    version = "0.19.1";
  };
  thread_safe = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1hq46wqsyylx5afkp6jmcihdpv4ynzzq9ygb6z2pb1cbz5js0gcr";
      type = "gem";
    };
    version = "0.3.5";
  };
  tilt = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0lgk8bfx24959yq1cn55php3321wddw947mgj07bxfnwyipy9hqf";
      type = "gem";
    };
    version = "2.0.5";
  };
  turbolinks = {
    dependencies = ["turbolinks-source"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0rvpjy97h1cz1pv14bm5k2acc0hf9dw674hf95n5h6p2abvpgs30";
      type = "gem";
    };
    version = "5.0.1";
  };
  turbolinks-source = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1s197pamkac9kkhslj41gxxihx6jp3dh4g394k9zmbxwkfrf36zb";
      type = "gem";
    };
    version = "5.0.0";
  };
  tzinfo = {
    dependencies = ["thread_safe"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1c01p3kg6xvy1cgjnzdfq45fggbwish8krd0h864jvbpybyx7cgx";
      type = "gem";
    };
    version = "1.2.2";
  };
  uglifier = {
    dependencies = ["execjs"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "07mjw5h3h4vg6w2cn57pxvlqgg6zy5vkp7sylznx1xzqfxnbkvy5";
      type = "gem";
    };
    version = "3.0.3";
  };
  unicorn = {
    dependencies = ["kgio" "raindrops"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ldb68m8zb283isiyjmy77kddj2rm0gjapb9cym16y12myxj38i5";
      type = "gem";
    };
    version = "5.2.0";
  };
  web-console = {
    dependencies = ["activemodel" "binding_of_caller" "railties" "sprockets-rails"];
    groups = ["development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0f8mgdjnkwb2gmnd73hnlx8p2clzvpz007alhsglqgylpj6m20jk";
      type = "gem";
    };
    version = "2.3.0";
  };
}
