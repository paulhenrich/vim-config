#!/usr/bin/env ruby

require 'fileutils'
require 'open-uri'


def vim_org_dl 
  vim_org_scripts = [
    ["jquery",        "12107", "syntax"],
    ["json",          "10853", "syntax"],
  ]


  bundles_dir = File.join(File.dirname(__FILE__), "bundle")

  FileUtils.cd(bundles_dir)

  vim_org_scripts.each do |name, script_id, script_type|
    puts "  Downloading #{name}"
    local_file = File.join(name, script_type, "#{name}.vim")
    FileUtils.rm_rf name
    FileUtils.mkdir_p(File.dirname(local_file))
    File.open(local_file, "w") do |file|
      file << open("http://www.vim.org/scripts/download_script.php?src_id=#{script_id}").read
    end
  end

end #/vim_org_dl

def git_sub
  git_bundles = [ 
    "git://github.com/wycats/nerdtree.git",
    "git://github.com/tpope/vim-fugitive.git",
    "git://github.com/tpope/vim-git.git",
    "git://github.com/tpope/vim-repeat.git",
    "git://github.com/tpope/vim-surround.git",
    "git://github.com/tpope/vim-vividchalk.git",
    "git://github.com/telemachus/vim-perlbrew.git",
    "git://github.com/scrooloose/nerdcommenter.git",
    "git://github.com/kikijump/tslime.vim.git",
    "git://github.com/vim-ruby/vim-ruby.git",
    "git://github.com/msanders/snipmate.vim.git",
    "git://github.com/vim-scripts/ZoomWin.git",
    "git://github.com/wincent/Command-T.git",
    "git://github.com/davidoc/taskpaper.vim.git",
    "git://github.com/vim-scripts/jade.vim.git",
    "git://github.com/tpope/vim-haml.git",
    "https://github.com/kchmck/vim-coffee-script.git",
  ]

  vim_dir     = File.dirname(__FILE__)
  FileUtils.cd(vim_dir)

  git_bundles.each do |url|
    dir = url.split('/').last.sub(/\.git$/, '')
    puts "  Unpacking #{url} into #{dir}"
    `git submodule add #{url} bundle/#{dir}`
    FileUtils.rm_rf(File.join(dir, ".git"))
  end

  `git submodule init`

end


git_sub()
vim_org_dl()
