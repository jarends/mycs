expect = require('chai').expect
CmdMap = require '../../js/cmd-map'


if typeof window == 'object'
    Emitter = require 'eventemitter3'
else
    Emitter = require 'events'


class TestCmd
    execute: (args...) ->
        TestCmd.executed = true
        TestCmd.args     = args
        TestCmd.ctx      = @ctx
        TestCmd.emitter  = @emitter


cmdFunc = (args...) ->
    TestCmd.executed = true
    TestCmd.args     = args


describe "cmd-map", () ->

    describe ".map", () ->

        it 'should map a command class', () ->
            ctx     = {}
            emitter = new Emitter()
            cmdMap  = new CmdMap emitter, ctx
            cmdMap.map 'testEvent', TestCmd
            expect(cmdMap.eventToCmd.hasOwnProperty 'testEvent').to.equal true

        it 'should map a object with an execute method', () ->
            ctx     = {}
            emitter = new Emitter()
            cmdMap  = new CmdMap emitter, ctx
            cmd     = new TestCmd()
            cmdMap.map 'testEvent', cmd
            expect(cmdMap.eventToCmd.hasOwnProperty 'testEvent').to.equal true

        it 'should map a function to an event', () ->
            ctx     = {}
            emitter = new Emitter()
            cmdMap  = new CmdMap emitter, ctx
            cmdMap.map 'testEvent', cmdFunc
            expect(cmdMap.eventToCmd.hasOwnProperty 'testEvent').to.equal true


    describe "execute", () ->

        it 'should execute a mapped command class', () ->
            ctx     = {}
            emitter = new Emitter()
            cmdMap  = new CmdMap emitter, ctx
            cmdMap.map 'testEvent', TestCmd
            emitter.emit 'testEvent', 'arg0'
            expect(TestCmd.executed).to.equal true
            expect(TestCmd.args[0]) .to.equal 'arg0'
            expect(TestCmd.ctx)     .to.equal ctx
            expect(TestCmd.emitter) .to.equal emitter


        it 'should execute a mapped objects execute method', () ->
            ctx     = {}
            emitter = new Emitter()
            cmdMap  = new CmdMap emitter, ctx
            cmd     = new TestCmd()
            cmdMap.map 'testEvent', cmd
            emitter.emit 'testEvent', 'arg0'
            expect(TestCmd.executed).to.equal true
            expect(TestCmd.args[0]) .to.equal 'arg0'


        it 'should execute a mapped function', () ->
            ctx     = {}
            emitter = new Emitter()
            cmdMap  = new CmdMap emitter, ctx
            cmdMap.map 'testEvent', cmdFunc
            emitter.emit 'testEvent', 'arg0'
            expect(TestCmd.executed).to.equal true
            expect(TestCmd.args[0]) .to.equal 'arg0'
