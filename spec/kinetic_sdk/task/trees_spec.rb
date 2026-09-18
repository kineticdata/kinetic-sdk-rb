require "spec_helper"

RSpec.describe KineticSdk::Task do
  let(:sdk) { task_sdk }
  let(:tree_file) do
    File.join(fixture_export_directory, "sources", "kinetic-task", "trees", "run-error.notify-on-run-error.xml")
  end

  # The import methods hand a File to import_tree, which calls File.basename on it
  # and posts it as multipart content. post_multipart is the seam: stubbing it keeps
  # the specs offline while still exercising import_tree.
  def stub_post_multipart(sdk)
    posts = []
    allow(sdk).to receive(:post_multipart) do |url, body, _headers|
      posts << { url: url, body: body }
      nil
    end
    posts
  end

  describe "the exported tree fixture" do
    # compare_trees looked trees up by //definitionId. Tree exports do not carry that
    # element -- only routine exports do -- so the lookup could never succeed. This
    # spec documents the constraint that made the comparison unfixable in place.
    it "has no definitionId element to identify it by" do
      doc = REXML::Document.new(File.read(tree_file))
      expect(REXML::XPath.first(doc, "//definitionId")).to be_nil
    end

    it "identifies the tree by source, group and name instead" do
      doc = REXML::Document.new(File.read(tree_file))
      expect(REXML::XPath.first(doc, "/tree/sourceName").text).to eq("Kinetic Task")
      expect(REXML::XPath.first(doc, "/tree/sourceGroup").text).to eq("Run Error")
      expect(REXML::XPath.first(doc, "/tree/taskTree/name").text).to eq("Notify on Run Error")
    end
  end

  describe "#import_trees" do
    it "raises when no export directory is configured" do
      expect { task_sdk(export_directory: nil).import_trees }
        .to raise_error(StandardError, /export directory must be defined/)
    end

    it "imports every tree in the export directory" do
      posts = stub_post_multipart(sdk)
      sdk.import_trees
      expect(posts.size).to eq(1)
      expect(posts.first[:url]).to include("/trees?force=false")
    end

    it "passes the force_overwrite flag through to the API" do
      posts = stub_post_multipart(sdk)
      sdk.import_trees(true)
      expect(posts.first[:url]).to include("/trees?force=true")
    end

    # Regression: compare_trees passed the File handle to REXML::XPath.first, which
    # raised NoMethodError (undefined method 'document' for an instance of File).
    it "does not raise when importing a real tree export" do
      stub_post_multipart(sdk)
      expect { sdk.import_trees }.not_to raise_error
    end

    # Regression: parsing the handle in place would leave it at EOF, uploading an
    # empty body for every tree.
    it "hands import_tree an unread file handle containing the full tree xml" do
      posts = stub_post_multipart(sdk)
      sdk.import_trees
      content = posts.first[:body]["content"]
      expect(content).to be_a(File)
      expect(content.pos).to eq(0)
      expect(content.read).to eq(File.read(tree_file))
    end
  end

  describe "#import_trees_threaded" do
    it "imports every tree in the export directory" do
      posts = stub_post_multipart(sdk)
      sdk.import_trees_threaded
      expect(posts.size).to eq(1)
      expect(posts.first[:url]).to include("/trees?force=false")
    end

    # Regression: the per-tree rescue was bare with an empty body, so failures were
    # discarded and the import reported success having imported nothing.
    it "logs and propagates a failure instead of swallowing it" do
      allow(sdk).to receive(:post_multipart).and_raise(ArgumentError, "boom")
      expect(sdk.logger).to receive(:error).with(/Failed to import Tree .*boom/)
      expect { sdk.import_trees_threaded }.to raise_error(ArgumentError, /boom/)
    end
  end
end
