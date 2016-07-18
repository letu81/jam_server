class Success
  def initialize(data={})
    @data = data
  end

  def as_json(options={})
    {
        code: 1,
        data: @data
    }
  end
end