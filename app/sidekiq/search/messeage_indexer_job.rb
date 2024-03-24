class Search::MesseageIndexerJob
  include Sidekiq::Worker
  sidekiq_options queue: :instabug_task_development_elasticsearch

  def perform(operation, record_id)
    record = Message.find(record_id)
    case operation.to_s
      when /index/
        record.__elasticsearch__.index_document    
      when /update/
        begin
          record.__elasticsearch__.update_document
        rescue Elasticsearch::Transport::Transport::Errors::NotFound
          logger.debug "Message not found, ID: #{record_id}"
        end
      else raise ArgumentError, "Unknown operation '#{operation}'"
    end
  end
end
