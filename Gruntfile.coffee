module.exports = (grunt) ->

  require('matchdep').filterDev('grunt-*').forEach(grunt.loadNpmTasks)

  grunt.initConfig

    rubyHaml:
      dist:
        files: grunt.file.expandMapping(['app/views/*.haml'], 'dist/',
          rename: (base, path) ->
            base + path.replace(/\.haml$/, '.html').replace('app/views/', '')
        )

    sass:
      dist:
        files:
          'dist/assets/stylesheets/main.css': 'app/assets/stylesheets/main.scss'

    coffeelint:
      app:
        files:
          src: ['app/assets/javascript/**/*.coffee']

    coffee:
      options:
        sourceMap: true

      compile:
        files:
          'dist/assets/javascript/app.js': ['app/assets/javascript/**/*.coffee']

    imagemin:
      all:
        files: [
          expand: true
          cwd: 'app/assets/images/'
          src: ['**/*.{png,jpg,jpeg}']
          dest: 'dist/assets/images/'
        ]

    svgmin:
      all:
        files: [
          expand: true
          cwd: 'app/assets/images/'
          src: ['**/*.svg']
          dest: 'dist/assets/images/'
        ]

    bower_concat:
      all:
        dest: 'dist/assets/javascript/plugins.js'
        cssDest: 'dist/assets/stylesheets/plugins.css'

    copy:
      main:
        files: [
          {
            expand: true
            cwd: 'app/assets/webfonts'
            src: '**'
            dest: 'dist/assets/webfonts'
          }
        ]

    watch:
      haml:
        files: ['app/views/**/*.haml']
        tasks: ['rubyHaml', 'notify:watch']

      coffee:
        files: ['app/assets/javascript/**/*.coffee']
        tasks: ['coffeelint', 'coffee', 'notify:watch']

      sass:
        files: ['app/assets/stylesheets/**/*.scss']
        tasks: ['sass', 'notify:watch']

      img:
        files: ['app/assets/images/**/*.{jpg,png,jpeg}']
        tasks: ['imagemin', 'notify:watch']

      webfonts:
        files: ['app/assets/fonts/**']
        tasks: ['copy', 'notify:watch']

      dist:
        files: ['dist/assets/stylesheets/**/*.css', 'dist/**/*.html', 'dist/assets/images/**/*', 'dist/assets/javascript/**/*.js']
        options:
          livereload: true

    connect:
      server:
        options:
          port: 1337
          base: 'dist'

    open:
      dev:
        path: 'http://localhost:1337/'
        app: 'Google Chrome'

    notify_hooks:
      enabled: true

    notify:
      watch:
        options:
          title: 'Task complete'
          message: 'Dist files successfully updated'

      server:
        options:
          title: 'Server started'
          message: 'Server started at http://localhost:1337'


  grunt.registerTask 'default', ['bower_concat', 'rubyHaml', 'sass', 'imagemin', 'svgmin', 'coffeelint', 'coffee', 'copy']
  grunt.registerTask 'dist', ['bower_concat', 'rubyHaml', 'sass', 'imagemin', 'svgmin', 'coffeelint', 'coffee', 'copy']
  grunt.registerTask 'server', ['default', 'connect', 'notify:server', 'open:dev', 'watch']
