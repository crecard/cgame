class Creacard::StatusAttribute < Creacard::Attribute
  def act!(targets:)

    targets.each do |t|
      t.update_status!(status_class, value, nil)
    end
  end

  def description
    "赋予 #{status_class.name} 状态"
  end

  def status_class
    return @status_class if @status_class

    status_name = @args['status'].split('_').map(&:capitalize).join
    @status_class = Object.const_get("Creacard::#{status_name}Status")
  end
end
