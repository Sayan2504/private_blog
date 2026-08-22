module AboutHelper
  # Sayan started working as a software engineer in 2020. Every "how long"
  # on the About page is derived from this one year rather than typed out, so
  # the page ages by itself: 6+ in 2026, 7+ in 2027, with nothing to remember
  # to edit. A hardcoded number is a fact that silently goes wrong.
  CAREER_START_YEAR = 2020

  # Completed years in the field. Rendered as "N+ years" everywhere, so the
  # partial year still in progress is covered by the plus rather than by
  # rounding up.
  def years_of_experience
    Date.current.year - CAREER_START_YEAR
  end
end
