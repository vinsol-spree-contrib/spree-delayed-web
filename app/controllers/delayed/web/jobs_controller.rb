module Delayed
  module Web
    class JobsController < Delayed::Web::ApplicationController

      before_action :find_job, only: [:show, :queue, :destroy]

      def index
        @jobs = Delayed::Web::Job.all
      end

      def queue
        if @job.can_queue?
          @job.queue!
          flash[:notice] = t(:notice, scope: 'delayed/web.flashes.jobs.queued')
        else
          status = t(@job.status, scope: 'delayed/web.views.statuses')
          flash[:alert] = t(:alert, scope: 'delayed/web.flashes.jobs.queued', status: status)
        end
        redirect_to jobs_path
      end

      def destroy
        if @job.can_destroy?
          @job.destroy
          flash[:notice] = t(:notice, scope: 'delayed/web.flashes.jobs.destroyed')
        else
          status = t(@job.status, scope: 'delayed/web.views.statuses')
          flash[:alert] = t(:alert, scope: 'delayed/web.flashes.jobs.destroyed', status: status)
        end
        redirect_to jobs_path
      end

      private

        def find_job
          begin
            @job = Delayed::Web::Job.find(params[:id])
          rescue ActiveRecord::RecordNotFound
            flash[:notice] = t(:notice, scope: 'delayed/web.flashes.jobs.executed')
            redirect_to jobs_path
          end
        end

    end
  end
end
