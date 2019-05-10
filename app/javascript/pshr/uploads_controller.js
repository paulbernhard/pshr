import { Controller } from 'stimulus'

export default class extends Controller {

  static targets = ['uploader', 'uploads']

  // add response to uploads container
  add(event) {
    const [response, status, xhr] = event.detail
    this.uploadsTarget.insertAdjacentHTML('beforeend', response.html)
  }

  // replace event.target with response
  reload(event) {
    const [response, status, xhr] = event.detail
    event.target.outerHTML = response.html
  }

  // delete event.target
  remove(event) {
    event.stopPropagation()
    const upload = event.target.closest('form')
    upload.parentNode.removeChild(upload)
  }
}
