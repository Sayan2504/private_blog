module ApplicationHelper
  # The auth screens all wear the same card and the same fields, and the class
  # string for one input had been copied verbatim into every one of them —
  # eleven times across five views. Adding the profile fields to sign-up would
  # have made that sixteen, so it lives here now and the views name it.
  AUTH_FIELD_CLASSES = "w-full rounded-lg border border-gray-300 dark:border-gray-600 " \
                       "bg-white dark:bg-gray-900 px-4 py-2.5 text-gray-900 dark:text-gray-100 " \
                       "placeholder-gray-400 dark:placeholder-gray-500 " \
                       "focus:border-gray-900 dark:focus:border-gray-100 transition-colors"

  AUTH_LABEL_CLASSES = "block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1.5"

  AUTH_HINT_CLASSES = "text-xs text-gray-500 dark:text-gray-400 mb-1.5"

  # The full-width submit on each auth card. It was copied into four views with
  # drift already setting in — one had lost `cursor-pointer` — and none of them
  # had a busy state, so a submitting form looked identical to an idle one.
  # Turbo disables the button and swaps its label for the length of the
  # request, and `disabled:` is what makes that visible.
  AUTH_SUBMIT_CLASSES = "w-full cursor-pointer rounded-lg bg-gray-900 px-4 py-2.5 font-medium text-white " \
                        "transition-colors hover:bg-gray-700 " \
                        "disabled:cursor-not-allowed disabled:opacity-60 " \
                        "dark:bg-gray-100 dark:text-gray-900 dark:hover:bg-gray-300"

  def auth_field_classes
    AUTH_FIELD_CLASSES
  end

  def auth_label_classes
    AUTH_LABEL_CLASSES
  end

  def auth_hint_classes
    AUTH_HINT_CLASSES
  end

  def auth_submit_classes
    AUTH_SUBMIT_CLASSES
  end

  # "Optional" belongs in the label, not on a line of its own underneath it.
  # As a separate hint it added a row's height to one field and not its
  # neighbour, so two inputs sharing a grid row no longer shared a baseline.
  def optional_marker
    tag.span "(optional)", class: "font-normal text-gray-400 dark:text-gray-500"
  end
end
