import { Controller } from 'stimulus'

const Uppy = require('@uppy/core')
const Tus = require('@uppy/tus')
const DragDrop = require('@uppy/drag-drop')
const Informer = require('@uppy/informer')

export default class extends Controller {

  static targets = ['file', 'drop', 'thumb', 'informer', 'progress']

  // TODO add a unique uppy id

  // handler when uploader is connected to DOM
  connect() {
    this.uppy = Uppy({
        id: this.element.id,
        autoProceed: true,
        allowMultipleUploads: true,
        restrictions: {
          maxNumberOfFiles: this.maxNumberOfFiles,
          allowedFileTypes: this.whitelist,
          maxFileSize: this.maxFileSize
        }
      })
      .use(DragDrop, {
        target: this.dropTarget
      })
      .use(Tus, {
        endpoint: this.data.get('endpoint'),
        chunkSize: 5*1024*1024
      })
      .use(Informer, {
        target: this.informerTarget
      })

    // starting to upload
    // remove any eventual messages from informer
    this.uppy.on('upload', (data) => {
      this.uppy.info('')
    })

    // update progress bar
    this.uppy.on('upload-progress', (file, progress) => {
      this.progress(file, progress)
    })

    // single upload succeeded
    // update file field for form and preview uploaded file
    this.uppy.on('upload-success', (file, response) => {
      console.log(file, response)

      const fileData = JSON.stringify({
        id: response.uploadURL,
        storage: "cache",
        metadata: {
          filename: file.name,
          size: file.size,
          mime_type: file.type
        }
      })

      this.fileTarget.value = fileData

      // TODO enable automatic form submission for uploader
      if (this.autoSubmit && false) {
        this.submit()
      } else {
        this.preview(file)
      }
    })

    this.element.closest('form').addEventListener('submit', (event) => {
      this.reset()
    })
  }

  // update progress with filename, percentage
  // and ASCII progress bar
  progress(file, progress) {
    const filename = file.name
    const percentage = parseFloat(progress.bytesUploaded / progress.bytesTotal * 100).toFixed(2)

    const bar = document.createElement('div')
    bar.innerHTML = "#".repeat(200)
    bar.style.cssText = `width: ${percentage}%; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;`

    this.progressTarget.innerHTML = `<strong>${percentage}%</strong> uploading ${file.id}`
    this.progressTarget.appendChild(bar)
  }

  // preview the uploaded file in thumb
  preview(file) {
    this.thumbTarget.innerHTML = `<span>${file.type}<br>${file.name}</span>`
    const url = URL.createObjectURL(file.data)

    if (file.type.includes("image")) {
      this.thumbTarget.innerHTML = `<img src="${url}">`
    } else if (file.type.includes("video")) {
      this.thumbTarget.innerHTML = `<video src="${url}" preload="metadata"></video>`
    } else {
      this.thumbTarget.innerHTML = `<span>${file.type}<br>${file.name}</span>`
    }
  }

  // handler to submit the form
  submit() {
    const form = this.element.closest("form")
    Rails.fire(form, "submit")
  }

  // reset the uppy instance and progress bar
  reset() {
    this.progressTarget.innerHTML = ""
    this.thumbTarget.innerHTML = "<span>Upload new file…</span>"
    this.uppy.reset()
  }

  // handler when uploader is removed from DOM
  disconnect() {
    this.uppy.close()
  }

  // getters for data settings
  // data-whitelist is a comma-seperated list of allowed mime-types
  // data-max-file-size defines a max file size in bytes
  // data-max-number-of-files sets a maximum number for multiple file uploads (currently disabled)

  get whitelist() {
    const whitelist = this.data.get('whitelist')
    return whitelist != "false" ? whitelist.split(',').map(type => type.trim()) : null
  }

  get maxNumberOfFiles() {
    const maxNumberOfFiles = this.data.get('maxNumberOfFiles')
    return maxNumberOfFiles != "false" ? maxNumberOfFiles : null
  }

  get maxFileSize() {
    const maxFileSize = this.data.get('maxFileSize')
    return maxFileSize != "false" ? parseInt(maxFileSize) : null
  }

  get autoSubmit() {
    const autoSubmit = this.data.get("autoSubmit")
    return autoSubmit == "true" ? true : false
  }
}
