import { Controller } from 'stimulus'

export default class extends Controller {

  static targets = ['uploader', 'uploads']

  // add form element
  add(event) {
    const [response, status, xhr] = event.detail
    this.uploadsTarget.insertAdjacentHTML('beforeEnd', response.html)
  }

  // remove form element
  // method of removal can be set by data-pshr--uploads-on-remove
  // default: "delete"
  remove(event) {
    console.log(this.onRemove)
    if (this.onRemove == "reload") {
      this.reload(event)
    } else {
      this.delete(event)
    }
  }

  // reload form element
  reload(event) {
    const [response, status, xhr] = event.detail
    const form = event.target.closest('form')
    form.outerHTML = response.html
  }

  // delete form element
  delete(event) {
    event.stopPropagation()
    const form = event.target.closest('form')
    form.parentNode.removeChild(form)
  }

  // get onRemove method from data attribute
  // default: delete
  get onRemove() {
    return this.data.get("onRemove") == "reload" ? "reload" : "delete"
  }
}
