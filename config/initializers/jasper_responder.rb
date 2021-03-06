require "rails"
require "rjb"

Mime::Type.register "application/pdf", :pdf

module JasperRails

  classpath = '.'

  Dir["lib/java/*.jar"].each do |jar|
    classpath << File::PATH_SEPARATOR + File.expand_path(jar)
  end

  Rjb::load( classpath, ['-Djava.awt.headless=true','-Xms128M', '-Xmx256M'] )

  JRException                 = Rjb::import 'net.sf.jasperreports.engine.JRException'
  JasperCompileManager        = Rjb::import 'net.sf.jasperreports.engine.JasperCompileManager'
  JasperExportManager         = Rjb::import 'net.sf.jasperreports.engine.JasperExportManager'
  JasperFillManager           = Rjb::import 'net.sf.jasperreports.engine.JasperFillManager'
  JasperPrint                 = Rjb::import 'net.sf.jasperreports.engine.JasperPrint'
  JRXmlUtils                  = Rjb::import 'net.sf.jasperreports.engine.util.JRXmlUtils'
  JRXPathQueryExecuterFactory = Rjb::import 'net.sf.jasperreports.engine.query.JRXPathQueryExecuterFactory'
  InputSource                 = Rjb::import 'org.xml.sax.InputSource'
  StringReader                = Rjb::import 'java.io.StringReader'
  HashMap                     = Rjb::import 'java.util.HashMap'
  ByteArrayInputStream        = Rjb::import 'java.io.ByteArrayInputStream'
  JavaString                  = Rjb::import 'java.lang.String'
  JFreeChart                  = Rjb::import 'org.jfree.chart.JFreeChart'

  module Jasper
    module Rails
      def self.render_pdf(jasper_file, datasource, parameters, options)
        options ||= {}
        parameters ||= {}
        jrxml_file  = jasper_file.sub(/\.jasper$/, ".jrxml")

        begin
          # Convert the ruby parameters' hash to a java HashMap.
          # Pay attention that, for now, all parameters are converted to string!
          jasper_params = HashMap.new
          parameters.each do |k,v|
            jasper_params.put(JavaString.new(k.to_s), JavaString.new(v.to_s))
          end

          # Compile it, if needed
          if !File.exist?(jasper_file) || (File.exist?(jrxml_file) && File.mtime(jrxml_file) > File.mtime(jasper_file))
            JasperCompileManager.compileReportToFile(jrxml_file, jasper_file)
          end

          # Fill the report
          input_source = InputSource.new
          input_source.setCharacterStream(StringReader.new(datasource.to_xml(options).to_s))
          data_document = silence_warnings do
            # This is here to avoid the "already initialized constant DOCUMENT_POSITION_*" warnings.
            # It's harmless. But pretty annoying.
            JRXmlUtils._invoke('parse', 'Lorg.xml.sax.InputSource;', input_source)
          end

          jasper_params.put(JRXPathQueryExecuterFactory.PARAMETER_XML_DATA_DOCUMENT, data_document)
          jasper_print = JasperFillManager.fillReport(jasper_file, jasper_params)

          # Export it!
          JasperExportManager._invoke('exportReportToPdf', 'Lnet.sf.jasperreports.engine.JasperPrint;', jasper_print)
        rescue Exception=>e
          if e.respond_to? 'printStackTrace'
            puts e.message
            e.printStackTrace
          else
            puts e.message
            puts e.backtrace
          end
        end
      end
    end
  end

  class ActionController::Responder
    def to_pdf
      jasper_file = "app/views/#{controller.controller_path}/#{controller.action_name}.jasper"

      params = {}
      controller.instance_variables.each do |v|
        params[v.to_s[1..-1]] = controller.instance_variable_get(v)
      end

      controller.send_data Jasper::Rails::render_pdf(jasper_file, resource, params, options), :type => Mime::PDF
    end
  end

end
