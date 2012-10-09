class ScheduleAttributes::FormBuilder < Formtastic::FormBuilder

  def weekdays
    Hash[ I18n.t('date.day_names').zip(ScheduleAttributes::DAY_NAMES) ]
  end

  def ordinal_month_days
    (1..31).map { |d| [d.ordinalize, d] }
  end

  def ordinal_month_weeks
    Hash["first", 1, "second", 2, "third", 3, "fourth", 4, "last", -1]
  end

  def one_time_fields(options={}, &block)
    hidden = object.repeat.to_i == 1
    @template.content_tag :div, hiding_field_options("schedule_one_time_fields", hidden, options), &block
  end

  def repeat_fields(options={}, &block)
    hidden = object.repeat.to_i != 1
    @template.content_tag :div, hiding_field_options("schedule_repeat_fields", hidden, options), &block
  end

  def ordinal_fields(options={}, &block)
    hidden = object.interval_unit == 'month' && object.by_day_of == 'week'
    @template.content_tag :div, hiding_field_options("schedule_ordinal_fields", hidden, options), &block
  end

  def weekday_fields(options={}, &block)
    hidden = false
    @template.content_tag :div, hiding_field_options("schedule_weekday_fields", hidden, options), &block
  end

  def hiding_field_options(class_name, hidden=false, options={})
    hidden_style = "display: none" if hidden
    options.tap do |o|
      o.merge!(style: [o[:style], hidden_style].compact.join('; '))
      o.merge!(class: [o[:class], class_name].compact.join(' '))
    end
  end
end
