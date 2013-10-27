if Meteor.isClient
  Template.hello.greeting = () ->
    "Welcome to philo-interviews."

  Template.hello.events({
    'click input': () ->
      # tbbemplate data, if any, is available in 'this'nn
      if typeof console != 'undefined'
        console.log("You pressed the button")
  })

if Meteor.isServer
  Meteor.startup(() ->
    # code to run on server at startup
  )


# Original CS
app = app || {}

app.TABLE_ID = '#time-select'
app.selecting = false
app.deleting = false
app.rowCol = []

app.init = ->
  selectTableCells = $(app.TABLE_ID).find('td')
  selectTableCells.click(app.toggleSelection)
  selectTableCells.mousemove(app.updateSelection)
  $('#calendar-form').submit(app.submitDates)


app.getRowCol = (el) ->
  $el = $(el)
  return [$el.index(), $el.parent().index()]


app.toggleSelection = (el) ->
  rowCol = app.getRowCol(this)
  app.deleting = $(this).hasClass('selected')
  if app.selecting
    app.selectRange(rowCol, app.rowCol, true)
    app.selecting = false
    app.rowCol = []
    if app.isSubmitted
      $('#submit-btn').removeClass('disabled')
    else
      $('#submit-btn').addClass('disabled')
  else
    app.selecting = true
    app.select(this)
    app.rowCol = rowCol


app.isSubmitReady = ->
  $('.selected').length > 0


app.select = (el) ->
  $(el).addClass('active')


app.deselect = (el) ->
  $(el).addClass('inactive')


app.updateSelection = (e) ->
  if app.selecting
    cur = app.getRowCol(this)
    app.selectRange(cur, app.rowCol)


app.selectRange = (pos1, pos2, isFinal) ->
  min = Math.min
  max = Math.max
  minCol = min(pos1[0], pos2[0]) + 1
  minRow = min(pos1[1], pos2[1]) + 1
  maxCol = max(pos1[0], pos2[0]) + 1
  maxRow = max(pos1[1], pos2[1]) + 1

  $('td').removeClass('active').removeClass('inactive')
  for row in [minRow..maxRow]
    for col in [minCol..maxCol]
      cell = $(app.TABLE_ID)
        .find('tr:nth-child(#{row})')
        .find('td:nth-child(#{col})')
      if isFinal
        if app.deleting
          cell.removeClass('selected')
        else
          cell.addClass('selected')
      else
        if app.deleting
          app.deselect(cell)
        else
          app.select(cell)


app.submitDates = (e) ->
  console.log('Submit dates!')
