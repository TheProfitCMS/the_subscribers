@TheSubscribers = do ->
  select_all: ->
    $('[name=selected_subscriber]').prop('checked', true)

  unselect_all: ->
    $('[name=selected_subscriber]').prop('checked', false)

  selected_ids: ->
    vals = $('[name=selected_subscriber]:checked').map (i,e) -> return $(e).val()
    $.map(vals, (x) -> x).join(',')

  set_selected_ids: ->
    $('[data-role="delete_selected"]').data('params').selected = @selected_ids()

  init_unsubscribe_button: ->
    $('button.unsubscribe_button').click ->
      window.prompt $(@).attr('data-title'), $(@).attr('data-text')

  init_select_all_btn: ->
    $('[name=select_all]').on 'change', (e) =>
      if $(e.target).is(':checked')
        do @select_all
      else
        do @unselect_all

      do @set_selected_ids

  init_checkboxes: ->
    $('[name=selected_subscriber]').on 'change', => do @set_selected_ids

  init_after_delete: ->
    $('[data-role="delete_selected"]').on 'ajax:success', ->
      for cbox in $('[name=selected_subscriber]:checked')
        cbox = $ cbox
        row  = cbox.parents('tr')

        cbox.prop 'checked', false
        $('[name=select_all]').prop 'checked', false

        row.remove()
        location.reload()

  init: ->
    if $('[name=selected_subscriber]').length
      do @init_unsubscribe_button
      do @init_select_all_btn
      do @init_checkboxes
      do @set_selected_ids
      do @init_after_delete

