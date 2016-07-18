class Failure
  def initialize(code =0, message)
    @code = code
    @message = message
  end

  def as_json(options={})
    {
        code: @code,
        message: @message
    }
  end
end