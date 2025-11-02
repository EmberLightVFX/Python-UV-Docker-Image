from nicegui import ui

@ui.page('/')
def index():
    ui.label('Hello from NiceGUI UV Docker!')
    ui.button('Click me!', on_click=lambda: ui.notify('Button clicked!'))

ui.run(host='0.0.0.0', port=8080)
