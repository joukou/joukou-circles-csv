"use strict"

###*
Copyright 2014 Joukou Ltd

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

  http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
###

###*
@class joukou-circles-csv.Csv2Joukou
@extends joukou-circle-core.Circle
@requires joukou-circle-core
@requires csv
###

{ InPort, OutPort, Circle } = require( 'joukou-circle-core' )

module.exports = class extends Circle

  ###*
  @private
  @static
  @property {Csv2Joukou} self
  ###
  self = @

  ###*
  @private
  @static
  @property {lodash} _
  ###
  _ = require( 'lodash' )

  ###*
  @private
  @static
  @property {csv} csv
  ###
  csv = require( 'csv' )

  { inspect } = require( 'util' )

  ###*
  @method constructor
  @cfg config A config object
  @cfg config.inPorts {Object}
  @cfg config.outPorts {Object}
  ###
  constructor: ( config ) ->

    _.assign( config,
      inPorts:
        in: new InPort(
          datatype: 'csv'
          required: true
        )
        columns: new InPort(
          datatype: 'datum'
          required: false
        )
      outPorts:
        out: new OutPort(
          datatype: 'datum'
          required: true
        )
        error: new OutPort(
          datatype: 'error'
          required: false
        )
    )

    super( config )

    csv()
      .from.stream( @inPorts.in )
      .to.stream( @outPorts.out )
      .transform( ( row ) ->
        console.log(inspect(row))
        row
      )
      .on( 'record', ( row, index ) ->
        console.log( "\##{index} #{JSON.stringify( row )}")
      )
      .on( 'close', ( count ) ->
        console.log( "Number of lines: #{count}")
      )
      .on( 'error', ( err ) ->
        console.log( err.message )
      )