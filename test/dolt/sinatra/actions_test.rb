# encoding: utf-8
#--
#   Copyright (C) 2012 Gitorious AS
#
#   This program is free software: you can redistribute it and/or modify
#   it under the terms of the GNU Affero General Public License as published by
#   the Free Software Foundation, either version 3 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU Affero General Public License for more details.
#
#   You should have received a copy of the GNU Affero General Public License
#   along with this program.  If not, see <http://www.gnu.org/licenses/>.
#++
require "test_helper"
require "dolt/sinatra/actions"

class DummySinatraApp
  include Dolt::Sinatra::Actions
  attr_reader :actions, :renderer

  def initialize(actions, renderer)
    @actions = actions
    @renderer = renderer
  end

  def body(str = nil)
    @body = str if !str.nil?
    @body
  end

  def response
    if !@response
      @response = {}
      def @response.status; @status; end
      def @response.status=(status); @status = status; end
    end
    @response
  end

  def tree_url(repo, ref, path)
    "/#{repo}/tree/#{ref}:#{path}"
  end

  def blob_url(repo, ref, path)
    "/#{repo}/blob/#{ref}:#{path}"
  end
end

class Renderer
  def initialize(body = ""); @body = body; end

  def render(action, data)
    @action = action
    @data = data
    @body
  end
end

class BlobStub
  def is_a?(type)
    type == Rugged::Blob
  end
end

class TreeStub
  def is_a?(type)
    type == Rugged::Tree
  end
end

class Actions
  attr_reader :repo, :ref, :path

  def initialize(blob = BlobStub.new)
    @blob = blob
  end

  def blob(repo, ref, path)
    @repo = repo
    @ref = ref
    @path = path

    yield nil, {
      :ref => ref,
      :repository => repo,
      :blob => @blob
    }
  end
end

describe Dolt::Sinatra::Actions do
  describe "#blob" do
    it "delegates to actions" do
      actions = Actions.new
      app = DummySinatraApp.new(actions, Renderer.new)
      app.blob("gitorious", "master", "app/models/repository.rb")

      assert_equal "gitorious", actions.repo
      assert_equal "master", actions.ref
      assert_equal "app/models/repository.rb", actions.path
    end

    it "renders the blob template as html" do
      app = DummySinatraApp.new(Actions.new, Renderer.new("Blob"))
      app.blob("gitorious", "master", "app/models/repository.rb")

      assert_equal "text/html", app.response["Content-Type"]
      assert_equal "Blob", app.body
    end

    it "redirects tree views to tree action" do
      app = DummySinatraApp.new(Actions.new(TreeStub.new), Renderer.new("Blob"))
      app.blob("gitorious", "master", "app/models")

      assert_equal 302, app.response.status
      assert_equal "/gitorious/tree/master:app/models", app.response["Location"]
      assert_equal "", app.body
    end
  end
end
