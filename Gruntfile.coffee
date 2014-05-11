module.exports = (grunt) ->
  grunt.initConfig
    mochaTest:
      test:
        options:
          reporter: 'spec'
          require: 'coffee-script/register'
        src: 'specs/**/*'

    grunt.loadNpmTasks 'grunt-mocha-test'

    grunt.registerTask 'test', ['mochaTest']