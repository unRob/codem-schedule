class Api::JobsController < Api::ApiController
  def index;        jobs_index(Job.scoped); end
  def scheduled;    jobs_index(Job.scheduled); end
  def transcoding;  jobs_index(Job.transcoding); end
  def on_hold;      jobs_index(Job.on_hold); end
  def success;      jobs_index(Job.success); end
  def failed;       jobs_index(Job.failed); end
  
  def create
    job = Job.from_api(params)
    job.callback_url = api_jobs_url
    job.save
    respond_with job, :location => api_job_url(job)
  end
  
  def update
    job = Job.find(params[:id])
    job.enter(params[:status], params)
    respond_with job, :location => api_job_url(job)
  end
  
  def show
    job = Job.find(params[:id])
    job.update_status
    respond_with job
  end
  
  private
    def jobs_index(jobs)
      jobs = jobs.page(params[:page]).per(20)

      jobs.select do |job| 
        if job.state == Job::Processing || job.state == Job::Transcoding
          job.update_status
        end
      end

      respond_with jobs
    end
end
