import PropertyObject from howl.aux.moon

class Chunk extends PropertyObject
  new: (@buffer, @start_pos, @end_pos) =>
    super!

  @property text:
    get: =>
      @buffer.text\usub(@start_pos, @end_pos)
    set: (text) =>
      @buffer\as_one_undo ->
        @delete!
        @buffer\insert text, @start_pos
        @end_pos = @start_pos + #text - 1

  delete: => @buffer\delete @start_pos, @end_pos if @end_pos >= @start_pos

  @meta {
    __tostring: => @text
    __len: => (@end_pos - @start_pos) + 1
  }

return Chunk
