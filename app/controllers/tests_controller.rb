class TestsController < Simpler::Controller

  def index
    #@time = Time.now

    render plain: 'Plain text response'

    status 201

    headers['Content-Type'] = 'text/html'
  end

  def create
  end

  def show
    @params = params[:id]
    @test = Test.find(id: @params)
  end

end
