import Gtk from lgi

import Buffer, keyhandler, bundle from lunar
import Editor from lunar.ui

bundle.load_by_name 'vi'

text = [[
Line 1
Line two
And third line
]]

describe 'VI', ->
  local buffer, lines
  editor = Editor Buffer {}
  cursor = editor.cursor
  window = Gtk.OffscreenWindow!
  window\add editor\to_gobject!
  window\show_all!

  before_each ->
    buffer = Buffer {}
    buffer.text = text
    lines = buffer.lines
    editor.buffer = buffer
    cursor.line = 2
    bundles.vi.state.reset!

  press = (...) ->
    for key in *{...}
      keyhandler.process editor, key_name: key, character: key, key_code: 123

  it '<j> moves down one line', ->
    press 'j'
    assert.equal 3, cursor.line

  it '<k> moves up one line', ->
    press 'k'
    assert.equal 1, cursor.line

  it '<h> moves to the left, or up a line if at the start of line', ->
    cursor.column = 2
    press 'h'
    assert.equal 1, cursor.column
    press 'h'
    assert.equal 1, cursor.line

  it '<l> moves to the right, or down a line if at the end of line', ->
    press 'l'
    assert.equal 2, cursor.column
    cursor\line_end!
    press 'l'
    assert.equal 3, cursor.line

  it '<r><character> replaces the current character with <character>', ->
    press 'r', 'F'
    assert.equal 'Fine two', lines[2].text
    
  describe '<d><d>', ->
    it 'removes the entire current line regardless of the current column', ->
      cursor.column = 4
      press 'd', 'd'
      assert.equal 'Line 1\nAnd third line\n', buffer.text
