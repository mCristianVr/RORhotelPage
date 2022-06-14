// Load all the controllers within this directory and all subdirectories. 
// Controller files must be named *_controller.js.

import { Application } from "stimulus"
import { definitionsFromContext } from "stimulus/webpack-helpers"

const application = Application.start()
const context = require.context("controllers", true, /_controller\.js$/)
application.load(definitionsFromContext(context))


// import Flatpickr
import Flatpickr from 'stimulus-flatpickr'

// Import style for flatpickr
require("flatpickr/dist/flatpickr.css")

// Manually register Flatpickr as a stimulus controller
application.register('flatpickr', Flatpickr)


export default class extends Flatpickr {

  // automatically submit form when a date is selected
  change(selectedDates, dateStr, instance) {
    alert( "noif." + selectedDates );

    if (selectedDates.lenght == 2) {
		const form = this.element.closest("form");
		form.append('<input type="hidden" name="disponibility" />');
		Rails.fire(form, "submit");
	}
  }
}