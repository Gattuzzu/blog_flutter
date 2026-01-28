// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../data/apis/blog_service.dart' as _i914;
import '../data/auth/auth_repository.dart' as _i157;
import '../data/auth/keycloak_data_source.dart' as _i594;
import '../data/persistence/local_persistence.dart' as _i792;
import '../data/repositorys/blog_repository.dart' as _i428;
import '../main_view_model.dart' as _i1051;
import '../ui/add_blog/add_blog_view_model.dart' as _i966;
import '../ui/blog_detail/blog_detail_view_model.dart' as _i461;
import '../ui/blog_overview/blog_overview_model.dart' as _i549;
import '../ui/profile/profile_view_model.dart' as _i168;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.factory<_i966.AddBlogViewModel>(() => _i966.AddBlogViewModel());
    gh.lazySingleton<_i914.BlogService>(() => _i914.BlogService());
    gh.lazySingleton<_i594.KeycloakDataSource>(
      () => _i594.KeycloakDataSource(),
    );
    gh.lazySingleton<_i792.LocalPersistence>(() => _i792.LocalPersistence());
    gh.lazySingleton<_i1051.MainViewModel>(
      () => _i1051.MainViewModel(persistence: gh<_i792.LocalPersistence>()),
    );
    gh.lazySingleton<_i157.AuthRepository>(
      () => _i157.AuthRepository(
        keycloakDataSource: gh<_i594.KeycloakDataSource>(),
        localPersistence: gh<_i792.LocalPersistence>(),
      ),
    );
    gh.lazySingleton<_i428.BlogRepository>(
      () => _i428.BlogRepository(service: gh<_i914.BlogService>()),
    );
    gh.factory<_i549.BlogOverviewModel>(
      () => _i549.BlogOverviewModel(
        blogRepository: gh<_i428.BlogRepository>(),
        authRepository: gh<_i157.AuthRepository>(),
      ),
    );
    gh.factory<_i168.ProfileViewModel>(
      () => _i168.ProfileViewModel(repository: gh<_i157.AuthRepository>()),
    );
    gh.factoryParam<_i461.BlogDetailViewModel, String, dynamic>(
      (blogId, _) => _i461.BlogDetailViewModel(
        blogRepository: gh<_i428.BlogRepository>(),
        authRepository: gh<_i157.AuthRepository>(),
        blogId: blogId,
      ),
    );
    return this;
  }
}
