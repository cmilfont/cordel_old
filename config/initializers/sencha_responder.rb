module Sencha
    class Wrapper
        attr_accessor :data, :total
    end

    class Responder < ActionController::Responder

        attr_reader :controller, :request, :format, :resource, :resources, :options
        def initialize(controller, resources, options={})
            super
            @controller = controller
            @request = @controller.request
            @format = @controller.formats.first
            @resource = resources.last
            @resources = resources
            @options = options

            @only    = options.delete(:only)
            @include = options.delete(:include)
			      @methods = options.delete(:methods)
        end

        def to_format
            to_sencha if @format == 'sencha'
            super
        end

        def to_sencha
            ActiveRecord::Base.include_root_in_json = false
            total = 1
            total = @resource.total_entries if @resource.respond_to?(:total_entries)

            if(@resource.respond_to?(:errors) && @resource.try(:errors).size > 0)

                model = @resource.class.name.camelize(:lower)
                @errors = { :attributes => {}, :base => @resource.try(:errors)[:base]}
                @resource.errors.each do |attr, msg|
                @errors[:attributes]["#{attr}"]    ||= []
                    @errors[:attributes]["#{attr}"]    << msg
                end
                render :json => {:success => 'false', :message => "", :errors => @errors},
                      :status => :unprocessable_entity
                      #, :location => @resource
            else
                sencha = {
                    :data => @resource, :total => total, :success => true, :message => ""
                }
                @params = { :include => @include, :methods => @methods }
                render :json => sencha.to_json( @params )
            end

        end

    end

end
