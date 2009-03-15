#line 1
use strict;
use warnings;
package Module::Install::JSONMETA;
use Module::Install::Base;

BEGIN {
  our @ISA = qw(Module::Install::Base);
  our $ISCORE  = 1;
  our $VERSION = '3.000';
}

#line 16

sub jsonmeta {
  my ($self) = @_;

  no warnings 'redefine';
  require Module::Install::Metadata;
  *Module::Install::Metadata::write = sub {
    my ($self) = @_;
    return $self unless $self->is_admin;

    unless (eval { require JSON; JSON->VERSION(2); 1 }) {
     die "could not load JSON.pm version 2 or better; can't use jsonmeta\n";
    }

    local *YAML::Tiny::Dump = sub {
      my $data = shift;
      $data->{generated_by} &&= __PACKAGE__
                              . ' version '
                              . __PACKAGE__->VERSION;
      JSON->new->ascii(1)->pretty->encode($data) . "\n"
    };
    
    $self->admin->write_meta;

    return $self;
  };
}

1;